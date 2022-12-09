module Decidim
  module Proposals
    # A command with all the business logic when a user publishes a collaborative_draft.
    class PublishCollaborativeDraft

      private

      def create_proposal!
        @new_proposal = Decidim.traceability.perform_action!(
          :create,
          Decidim::Proposals::Proposal,
          @current_user,
          visibility: "public-only"
        ) do
          new_proposal = Proposal.new(proposal_attributes.merge(@collaborative_draft.component.current_settings.moderation_enabled ? { published_at: nil } : {}))
          new_proposal.coauthorships = @collaborative_draft.coauthorships
          new_proposal.category = @collaborative_draft.category
          new_proposal.attachments = @collaborative_draft.attachments
          new_proposal.internal_state = @collaborative_draft.component.current_settings.moderation_enabled ? "review" : nil
          new_proposal.save!
          new_proposal
        end
      end

    end
  end
end