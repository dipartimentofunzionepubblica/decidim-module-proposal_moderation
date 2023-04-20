# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Crea lo notifica agli admin quando viene creato una nuova proposta

# frozen_string_literal: true

module Decidim
  module Proposals
    class NewReviewNotificationAdminCreator
      def initialize(proposal, priority = :low)
        @proposal = proposal
        @already_notified_users = [@proposal.creator]
        @priority = priority
      end

      def create
        notify_admins
      end

      private

      attr_reader :proposal, :already_notified_users

      def notify_admins
        notify(:admin, @proposal.participatory_space.moderators)
      end

      def notify(event, users)
        return if users.values.flatten.blank?

        Decidim::EventsManager.publish(
          event: "decidim.events.proposals.proposal_review",
          event_class: Decidim::Proposals::Admin::ReviewProposalEvent,
          resource: @proposal,
          followers: users
        )
      end
    end
  end
end
