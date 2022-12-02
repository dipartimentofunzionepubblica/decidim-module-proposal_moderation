# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/proposals"

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

      initializer "decidim_privacy.add_cells_view_paths" do
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
        current_stat = Decidim.find_component_manifest("proposals").stats.stats.detect{ |a| a[:name] == :proposals_count }
        current_stat[:block] = Proc.new { |components, start_at, end_at|
          Decidim::Proposals::Proposal.where(component: components).not_hidden.published.or(Decidim::Proposals::Proposal.where(component: components).not_hidden.in_review).count
        } if current_stat && current_stat.try(:[], :block)
        proposal_settings = Decidim.find_component_manifest("proposals").settings(:step)
        proposal_settings.attribute :moderation_enabled, type: :boolean, default: false
        proposal_settings.attribute :moderation_amendment_enabled, type: :boolean, default: false

        [ :accountability, :blogs, :budgets, :debates, :meetings, :proposals, :sortitions].each do |name|
          manifest = Decidim.find_component_manifest(name)
          settings = manifest.settings(:global) if manifest
          settings.attribute :moderation_comments_enabled, type: :boolean, default: false if settings
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
