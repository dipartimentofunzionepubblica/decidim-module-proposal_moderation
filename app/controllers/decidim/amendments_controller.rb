# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter gestire il flusso personalizzato dei nuovi stati in caso di moderazione abilitata.

# frozen_string_literal: true

require_dependency Decidim::Core::Engine.root.join('app', 'controllers', 'concerns', 'decidim', 'amendments_controller').to_s

module Decidim
  class AmendmentsController

    def new
      raise ActionController::RoutingError, "Not Found" unless amendable

      enforce_permission_to :create, :amendment, current_component: amendable.component

      amendment_draft = amendable.amendments.find_by(amender: current_user.id, state: "draft")

      if is_review_mode? && amendable.review?
        redirect_back fallback_location: :index, flash: { alert: I18n.t("proposals.create.cant_amend", scope: "decidim") } and return
      end

      if amendment_draft
        redirect_to edit_draft_amend_path(amendment_draft)
      else
        @form = form(Decidim::Amendable::CreateForm).from_params(params)
      end
    end

    def preview_draft
      enforce_permission_to :create, :amendment, current_component: amendable.component
      render is_review_mode? ? :review_draft : :preview_draft
    end

    def publish_draft
      enforce_permission_to :create, :amendment, current_component: amendable.component
      @form = form(Decidim::Amendable::PublishForm).from_model(amendment)

      if is_review_mode?
        Decidim::Amendable::ReviewDraft.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("success", scope: "decidim.amendments.review_draft")
            redirect_to Decidim::ResourceLocatorPresenter.new(emendation).path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("error", scope: "decidim.amendments.review_draft")
            render :edit_draft
          end
        end
      else
        Decidim::Amendable::PublishDraft.call(@form) do
          on(:ok) do |emendation|
            flash[:notice] = t("success", scope: "decidim.amendments.publish_draft")
            redirect_to Decidim::ResourceLocatorPresenter.new(emendation).path
          end

          on(:invalid) do
            flash.now[:alert] = t("error", scope: "decidim.amendments.publish_draft")
            render :edit_draft
          end
        end
      end
    end

    def accept
      enforce_permission_to :accept, :amendment, current_component: amendable.component

      @form = form(Decidim::Amendable::ReviewForm).from_params(params)
      if is_review_mode?
        Decidim::Amendable::ReviewAccepted.call(@form) do
          on(:ok) do |emendation|
            flash[:notice] = t("review_accepted.success", scope: "decidim.amendments")
            redirect_to Decidim::ResourceLocatorPresenter.new(emendation).path
          end

          on(:invalid) do
            flash.now[:alert] = t("review_accepted.error", scope: "decidim.amendments")
            render :review
          end
        end
      else
        Decidim::Amendable::Accept.call(@form) do
          on(:ok) do |emendation|
            flash[:notice] = t("accepted.success", scope: "decidim.amendments")
            redirect_to Decidim::ResourceLocatorPresenter.new(emendation).path
          end

          on(:invalid) do
            flash.now[:alert] = t("accepted.error", scope: "decidim.amendments")
            render :review
          end
        end
      end
    end

    def is_review_mode?
      amendable.component.try(:current_settings).try(:moderation_amendment_enabled) &&
        amendable.component.current_settings.amendments_visibility == "all" && !current_user&.admin?
      # Non ha senso mandare in revisione l'accettazione quando gli unici a poter accettare sono gli admin
      # se la visibilità degli emendamenti è settata ai soli autori (non della proposta)
    end
    helper_method :is_review_mode?

    # def permission_class_chain
    #   [Decidim::ProposalModeration::Permissions] + super
    # end

  end
end