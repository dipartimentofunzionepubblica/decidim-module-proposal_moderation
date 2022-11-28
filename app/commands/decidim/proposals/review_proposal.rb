# frozen_string_literal: true

module Decidim
  module Proposals
    # A command with all the business logic when a user publishes a draft proposal.
    class ReviewProposal < Rectify::Command
      # Public: Initializes the command.
      #
      # proposal     - The proposal to publish.
      # current_user - The current user.
      def initialize(proposal, current_user)
        @proposal = proposal
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid and the proposal is published.
      # - :invalid if the proposal's author is not the current user.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) unless @proposal.authored_by?(@current_user)

        transaction do
          review_proposal
          # increment_scores
          send_notification
          # send_notification_to_participatory_space
        end

        broadcast(:ok, @proposal)
      end

      private

      # This will be the PaperTrail version that is
      # shown in the version control feature (1 of 1)
      #
      # For an attribute to appear in the new version it has to be reset
      # and reassigned, as PaperTrail only keeps track of object CHANGES.
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

      # Reset the attribute to an empty string and return the old value
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
