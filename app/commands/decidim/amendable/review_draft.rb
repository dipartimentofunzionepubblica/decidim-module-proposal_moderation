# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce l'invio in revisione di un emendamento in caso di modulo abilitato

# frozen_string_literal: true

module Decidim
  module Amendable
    # A command with all the business logic when a user publishes an amendment draft.
    class ReviewDraft < Rectify::Command
      # Public: Initializes the command.
      #
      # form         - A form object with the params.
      def initialize(form)
        @form = form
        @amendment = form.amendment
        @amendable = form.amendable
        @emendation = form.emendation
        @amender = form.amender
        @current_user = form.current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the amend.
      # - :invalid if the amendment is not a draft.
      # - :invalid if the form isn't valid or the amender is not the current user.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) unless form.valid? && amendment.draft? && amender == current_user

        transaction do
          set_first_emendation_version
          review_emendation
          change_amendment_state_to_review
          send_notification
          # notify_emendation_state_change!
          # notify_amendable_authors_and_followers
        end

        broadcast(:ok, emendation)
      end

      private

      attr_reader :form, :amendment, :amendable, :emendation, :amender, :current_user

      # # To be able to diff amendments we store the original attributes being amended
      # # in the first PaperTrail::Version.
      def set_first_emendation_version
        emendation.update(form.amendable_params)
      end

      # This will be the PaperTrail version that gets compared to the amended proposal.
      def review_emendation
        Decidim.traceability.perform_action!(
          "review",
          emendation,
          current_user,
          visibility: "public-only"
        ) do
          emendation.update(form.emendation_params.merge(internal_state: "review"))
        end
      end

      def change_amendment_state_to_review
        # Per aggirare le validazioni in quanto gli STATES sono freezed e falliscono le validazioni
        emendation.amendment.update_column(:state, "review")
      end

      def send_notification
        affected_users = emendation.participatory_space.moderators

        Decidim::EventsManager.publish(
          event: "decidim.events.amendments.amendment_review",
          event_class: Decidim::Proposals::Admin::ReviewAmendmentEvent,
          resource: emendation,
          followers: affected_users
        )
      end

      # def notify_emendation_state_change!
      #   emendation.process_amendment_state_change!
      # end
      #
      # def notify_amendable_authors_and_followers
      #   Decidim::EventsManager.publish(
      #     event: "decidim.events.amendments.amendment_created",
      #     event_class: Decidim::Amendable::AmendmentCreatedEvent,
      #     resource: amendable,
      #     affected_users: amendable.notifiable_identities,
      #     followers: amendable.followers - amendable.notifiable_identities
      #   )
      # end
    end
  end
end
