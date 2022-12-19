require_dependency Decidim::Proposals::Engine.root.join('app', 'cells', 'decidim', 'proposals', 'highlighted_proposals_for_component_cell').to_s

module Decidim
  module Proposals
    class HighlightedProposalsForComponentCell

      def proposals
        @proposals ||= Decidim::Proposals::Proposal.published.not_hidden.except_withdrawn
                                                   .where(component: model)
                                                   .where.not(id: Proposal.not_in_moderation_rejected_for_user(current_user).ids)
                                                   .not_in_review
                                                   .order_randomly(rand * 2 - 1)
      end

    end
  end
end