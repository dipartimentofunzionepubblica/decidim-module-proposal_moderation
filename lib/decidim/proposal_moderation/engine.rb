# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/proposals"
require "decidim/searchable/comment"

module Decidim
  module ProposalModeration
    # This is the engine that runs on the public interface of proposal_moderation.
    class Engine < ::Rails::Engine
      # isolate_namespace Decidim::ProposalModeration

      routes do
        # Add engine routes here
        resources :comments, only: [] do
          member do
            put :publish, to: "decidim/comments/comments#publish"
            put :reject, to: "decidim/comments/comments#reject"
          end
        end
      end

      initializer "decidim_proposal_moderation.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_proposal_moderation.add_cells_view_paths" do
        # to override decidim-core I need to insert it first in view_paths
        Cell::ViewModel.view_paths.insert(1, File.expand_path("#{Decidim::ProposalModeration::Engine.root}/app/cells"))
        # Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Privacy::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ProposalModeration::Engine.root}/app/views") # for partials
      end

      initializer "decidim_proposals.mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::ProposalModeration::Engine, at: "/", as: "decidim_proposals"
        end
      end

      initializer "decidim_proposal_moderation.add_settings" do
        # salvataggio del current_user per poter riutilizzare i comandi definiti per la pubblicazione
        # delle proposte che validano che il current_user come admin
        ActiveSupport.on_load(:action_controller_base) do
          around_action :store_current_user, if: :only_component_update

          def store_current_user
            Thread.current[:current_user] = current_user
            yield
          ensure
            Thread.current[:current_user] = nil
          end

          def only_component_update
            controller_name == 'components' && action_name == "update"
          end
        end

        # definizione del current_user in questo contesto per i Command sotto
        def current_user
          Thread.current[:current_user]
        end

        current_stat = Decidim.find_component_manifest("proposals").stats.stats.detect{ |a| a[:name] == :proposals_count }
        current_stat[:block] = Proc.new { |components, start_at, end_at|
          Decidim::Proposals::Proposal.where(component: components).not_hidden.published.or(Decidim::Proposals::Proposal.where(component: components).not_hidden.in_review).count
        } if current_stat && current_stat.try(:[], :block)

        # Definizione settings necessari per il funzionamento del pacchetto
        proposal_settings = Decidim.find_component_manifest("proposals").settings(:step)
        proposal_settings.attribute :moderation_enabled, type: :boolean, default: false
        proposal_settings.attribute :moderation_amendment_enabled, type: :boolean, default: false

        # In caso di disabilitazione, vengono pubblicati tutti i commenti, proposte e emendamenti ancora in revisione.
        [ :accountability, :blogs, :budgets, :debates, :meetings, :proposals, :sortitions].each do |name|
          manifest = Decidim.find_component_manifest(name)
          settings = manifest.settings(:global) if manifest
          settings.attribute :moderation_comments_enabled, type: :boolean, default: false if settings
          manifest && manifest.on(:update) do |instance|
            if !instance.settings.moderation_comments_enabled
              current_organization = instance.organization
              Decidim::Comments::Comment.preload(root_commentable: :component).all.select{ |a| a.review? && a.root_commentable.component.id == instance.id }.each do |comment|
                form = Decidim::Comments::CommentForm.from_model(comment).with_context(current_organization: current_organization)
                Decidim::Comments::PublishComment.call(comment, nil, form)
              end
            end

            if !instance.current_settings.moderation_enabled
              Decidim::Proposals::Proposal.in_review.where(component: instance).each do |proposal|
                Decidim::Proposals::Admin::PublishProposal.call(proposal, Thread.current[:current_user]) do
                  # Wordkaroud to load current_user (Thread.current[:current_user]) with empty block
                end unless proposal.amendment
              end
            end

            if !instance.current_settings.moderation_amendment_enabled
              Decidim::Proposals::Proposal.in_review_accepted.where(component: instance).each do |proposal|
                Decidim::Amendable::Admin::Accept.call(proposal) do
                  # Wordkaroud to load current_user (Thread.current[:current_user]) with empty block
                end
              end

              Decidim::Proposals::Proposal.in_review.where(component: instance).each do |proposal|
                if proposal.amendment
                  form = Decidim::Amendable::PublishForm.from_model(proposal.amendment).with_context(
                    current_user: Thread.current[:current_user]
                  )
                  Decidim::Amendable::Admin::PublishDraft.call(form) do
                    # Wordkaroud to load current_user with empty block
                  end
                end
              end
            end
          end
        end
      end

      overrides = "#{Decidim::ProposalModeration::Engine.root}/app/overrides"
      config.to_prepare do
        Rails.autoloaders.main.ignore(overrides)
        Dir.glob("#{overrides}/**/*_override.rb").each do |override|
          load override
        end
      end

    end
  end
end
