# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce la pubblicazione di un emendamento da parte di un admin

# frozen_string_literal: true

module Decidim
  module Amendable
    module Admin
      class PublishDraft < ::Decidim::Amendable::PublishDraft

        def call
          return broadcast(:invalid) unless form.valid? && amendment.review? && current_user&.admin?

          transaction do
            set_first_emendation_version
            publish_emendation
            change_amendment_state_to_evaluating
            notify_emendation_state_change!
            notify_amendable_authors_and_followers
            notify_amendment_authors
          end

          broadcast(:ok, emendation)
        end

        def notify_amendment_authors
          Decidim::EventsManager.publish(
            event: "decidim.events.amendments.amendment_published_authors",
            event_class: Decidim::Proposals::Admin::PublishAmendmentEvent,
            resource: emendation,
            affected_users: emendation.authors,
            extra: {
              author_id: current_user.id
            }
          )
        end

      end
    end
  end
end
