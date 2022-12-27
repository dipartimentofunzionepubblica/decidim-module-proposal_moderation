# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce l'invio in revisione dell'accettazione di un emendamento in caso di modulo abilitato

# frozen_string_literal: true

module Decidim
  module Amendable
    class ReviewAccepted < Rectify::Command

      def initialize(form)
        @form = form
        @amendment = form.amendment
        @amendable = form.amendable
        @emendation = form.emendation
        @amender = form.emendation.creator_author
        @user_group = form.emendation.creator.user_group
        @current_user = form.current_user
      end

      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          @amendment.update_column(:state, "review_accepted")
          review_emendation
          send_notification
        end

        broadcast(:ok, @emendation)
      end

      private

      attr_reader :form, :amendment, :amendable, :emendation, :amender, :current_user

      def review_emendation
        Decidim.traceability.perform_action!(
          "review_accepted",
          emendation,
          current_user,
          visibility: "public-only"
        ) do
          emendation.assign_attributes(form.emendation_params)
          emendation.title = { I18n.locale => form.emendation_params.with_indifferent_access[:title] }
          emendation.body = { I18n.locale => form.emendation_params.with_indifferent_access[:body] }
          emendation.save!
          emendation.update_column(:internal_state, "review_accepted")
        end
      end

      def send_notification
        affected_users = current_user.organization.admins

        Decidim::EventsManager.publish(
          event: "decidim.events.amendments.acceptance_review",
          event_class: Decidim::Proposals::Admin::PublishAmendmentEvent,
          resource: emendation,
          followers: affected_users
        )
      end

    end
  end
end
