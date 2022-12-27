# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter gestire il flusso personalizzato dei nuovi stati in caso di moderazione abilitata.

# frozen_string_literal: true

require_dependency Decidim::Proposals::AdminEngine.root.join('app', 'controllers', 'decidim', 'proposals', 'admin', 'proposals_controller').to_s

module Decidim
  module Proposals
    module Admin
      class ProposalsController
        include Decidim::Proposals::Admin::FilterableOverrides
        include Decidim::ComponentPathHelper

        def publish
          enforce_permission_to :publish, :proposal, proposal: proposal

          if @proposal.amendment
            @form = form(Decidim::Amendable::PublishForm).from_model(@proposal.amendment)
            Decidim::Amendable::Admin::PublishDraft.call(@form) do
              on(:ok) do |emendation|
                redirect_back fallback_location: manage_component_path(current_component), flash: { notice: t("success", scope: "decidim.amendments.publish_draft") }
              end
              on(:invalid) do
                redirect_back fallback_location: manage_component_path(current_component), flash: { alert: t("error", scope: "decidim.amendments.publish_draft") }
              end
            end
          else
            Decidim::Proposals::Admin::PublishProposal.call(@proposal, current_user) do
              on(:ok) do
                redirect_back fallback_location: manage_component_path(current_component), flash: { notice: I18n.t("proposals.publish.success", scope: "decidim") }
              end
              on(:invalid) do
                redirect_back fallback_location: manage_component_path(current_component), flash: { alert: I18n.t("proposals.publish.error", scope: "decidim") }
              end
            end
          end
        end

        def reject
          enforce_permission_to :publish, :proposal, proposal: proposal

          if @proposal.amendment
            @form = form(Decidim::Amendable::PublishForm).from_model(@proposal.amendment)
            Decidim::Amendable::Admin::RejectDraft.call(@form) do
              on(:ok) do |emendation|
                redirect_back fallback_location: manage_component_path(current_component), flash: { notice: t("success", scope: "decidim.amendments.reject_draft") }
              end
              on(:invalid) do
                redirect_back fallback_location: manage_component_path(current_component), flash: { alert: t("error", scope: "decidim.amendments.reject_draft") }
              end
            end
          else
            Decidim::Proposals::Admin::RejectProposal.call(@proposal, current_user) do
              on(:ok) do
                redirect_back fallback_location: manage_component_path(current_component), flash: { notice: I18n.t("proposals.reject.success", scope: "decidim") }
              end
              on(:invalid) do
                redirect_back fallback_location: manage_component_path(current_component), flash: { alert: I18n.t("proposals.reject.error", scope: "decidim") }
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
              redirect_back fallback_location: manage_component_path(current_component), flash: { alert: I18n.t("accepted.error", scope: "decidim.amendments") }
            end
          end
        end

        def reject_acceptance
          enforce_permission_to :accept, :amendment, current_component: current_component

          @proposal = collection.find(params[:id])
          Decidim::Amendable::Admin::Reject.call(@proposal) do
            on(:ok) do |emendation|
              flash[:notice] = t("rejected.success", scope: "decidim.amendments")
              redirect_to Decidim::ResourceLocatorPresenter.new(emendation).path
            end
            on(:invalid) do
              redirect_back fallback_location: manage_component_path(current_component), flash: { alert: I18n.t("rejected.error", scope: "decidim.amendments") }
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
