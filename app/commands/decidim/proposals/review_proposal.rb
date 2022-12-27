# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce l'invio in revisione in caso di modulo abilitato

# frozen_string_literal: true

module Decidim
  module Proposals
    class ReviewProposal < Rectify::Command
      def initialize(proposal, current_user)
        @proposal = proposal
        @current_user = current_user
      end

      def call
        return broadcast(:invalid) unless @proposal.authored_by?(@current_user)

        transaction do
          review_proposal
          send_notification
        end

        broadcast(:ok, @proposal)
      end

      private

      def review_proposal
        title = reset(:title)
        body = reset(:body)

        Decidim.traceability.perform_action!(
          "review",
          @proposal,
          @current_user,
          visibility: "public-only"
        ) do
          @proposal.update title: title, body: body, state: "review"
        end
      end

      def reset(attribute)
        attribute_value = @proposal[attribute]
        PaperTrail.request(enabled: false) do
          @proposal.update_attribute attribute, ""
        end
        attribute_value
      end

      def send_notification
        affected_users = @current_user.organization.admins

        Decidim::EventsManager.publish(
          event: "decidim.events.proposals.proposal_review",
          event_class: Decidim::Proposals::Admin::PublishProposalEvent,
          resource: @proposal,
          followers: affected_users
        )
      end
    end
  end
end
