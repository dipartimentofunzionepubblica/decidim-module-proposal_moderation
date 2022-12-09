# frozen_string_literal: true

module Decidim
  module ProposalModeration
    # This is the engine that runs on the public interface of `ProposalModeration`.
    class AdminEngine < ::Rails::Engine
      # isolate_namespace Decidim::ProposalModeration::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        put "/participatory_processes/:participatory_process_slug/components/:component_id/manage/proposals/:id/publish", to: "decidim/proposals/admin/proposals#publish", as: :publish_process_proposal_admin
        put "/assemblies/:participatory_process_slug/components/:component_id/manage/proposals/:id/publish", to: "decidim/proposals/admin/proposals#publish", as: :publish_assembly_proposal_admin
        put "/conferences/:participatory_process_slug/components/:component_id/manage/proposals/:id/publish", to: "decidim/proposals/admin/proposals#publish", as: :publish_conference_proposal_admin
        put "/participatory_processes/:participatory_process_slug/components/:component_id/manage/proposals/:id/reject", to: "decidim/proposals/admin/proposals#reject", as: :reject_process_proposal_admin
        put "/assemblies/:participatory_process_slug/components/:component_id/manage/proposals/:id/reject", to: "decidim/proposals/admin/proposals#reject", as: :reject_assembly_proposal_admin
        put "/conferences/:participatory_process_slug/components/:component_id/manage/proposals/:id/reject", to: "decidim/proposals/admin/proposals#reject", as: :reject_conference_proposal_admin

        put "/participatory_processes/:participatory_process_slug/components/:component_id/manage/proposals/:id/accept", to: "decidim/proposals/admin/proposals#accept", as: :accept_process_proposal_admin
        put "/assemblies/:participatory_process_slug/components/:component_id/manage/proposals/:id/accept", to: "decidim/proposals/admin/proposals#accept", as: :accept_assembly_proposal_admin
        put "/conferences/:participatory_process_slug/components/:component_id/manage/proposals/:id/accept", to: "decidim/proposals/admin/proposals#accept", as: :accept_conference_proposal_admin
        put "/participatory_processes/:participatory_process_slug/components/:component_id/manage/proposals/:id/reject_acceptance", to: "decidim/proposals/admin/proposals#reject_acceptance", as: :reject_acceptance_process_proposal_admin
        put "/assemblies/:participatory_process_slug/components/:component_id/manage/proposals/:id/reject_acceptance", to: "decidim/proposals/admin/proposals#reject_acceptance", as: :reject_acceptance_assembly_proposal_admin
        put "/conferences/:participatory_process_slug/components/:component_id/manage/proposals/:id/reject_acceptance", to: "decidim/proposals/admin/proposals#reject_acceptance", as: :reject_conference_assembly_proposal_admin
      end

      initializer "decidim_proposals_admin.mount_routes" do
        Decidim::Admin::Engine.routes.append do
          mount Decidim::ProposalModeration::AdminEngine, at: "/", as: "decidim_proposals_admin"
        end
      end

      initializer "decidim_proposals_admin.view_helpers" do
        ActiveSupport.on_load(:action_controller_base) do
          helper Decidim::ProposalModeration::ApplicationHelper
        end
      end

      initializer "decidim_proposals_admin.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      def load_seed
        nil
      end
    end
  end
end
