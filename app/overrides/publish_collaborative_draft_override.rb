# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter mandare in revisione le bozze collaborative

module Decidim
  module Proposals
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