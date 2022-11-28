require_dependency Decidim::Proposals::AdminEngine.root.join('app', 'controllers', 'decidim', 'proposals', 'admin', 'proposals_controller').to_s

module Decidim
  module Proposals
    module Admin
      # Exposes the proposal resource so users can view and create them.
      class ProposalsController
        include Decidim::Proposals::Admin::FilterableOverrides

        def publish
          enforce_permission_to :publish, :proposal, proposal: proposal

          if @proposal.amendment
            @form = form(Decidim::Amendable::PublishForm).from_model(@proposal.amendment)
            Decidim::Amendable::Admin::PublishDraft.call(@form) do
              on(:ok) do |emendation|
                redirect_back fallback_location: proposals_path, flash: { notice: t("success", scope: "decidim.amendments.publish_draft") }
              end
              on(:invalid) do
                redirect_back fallback_location: proposals_path, flash: { alert: t("error", scope: "decidim.amendments.publish_draft") }
              end
            end
          else
            Decidim::Proposals::Admin::PublishProposal.call(@proposal, current_user) do
              on(:ok) do
                redirect_back fallback_location: proposals_path, flash: { notice: I18n.t("proposals.publish.success", scope: "decidim") }
              end
              on(:invalid) do
                redirect_back fallback_location: proposals_path, flash: { alert: I18n.t("proposals.publish.error", scope: "decidim") }
              end
            end
          end
        end

        def accept
          enforce_permission_to :accept, :amendment, current_component: current_component

          @proposal = collection.find(params[:id])
          Decidim::Amendable::Admin::Accept.call(@proposal) do
            on(:ok) do |emendation|
              flash[:notice] = t("accepted.success", scope: "decidim.amendments")
              redirect_to Decidim::ResourceLocatorPresenter.new(emendation).path
            end
            on(:invalid) do
              redirect_back fallback_location: proposals_path, flash: { alert: I18n.t("accepted.error", scope: "decidim.amendments") }
            end
          end
        end

        def permission_class_chain
          [Decidim::ProposalModeration::Admin::Permissions] + super
        end

        private

        def collection
          @collection ||= Proposal.where(component: current_component).not_hidden.published.or(Proposal.where(component: current_component).not_hidden.in_review)
        end

      end
    end
  end
end
