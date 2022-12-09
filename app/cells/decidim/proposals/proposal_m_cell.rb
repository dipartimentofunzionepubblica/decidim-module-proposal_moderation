require_dependency Decidim::Proposals::Engine.root.join('app', 'cells', 'decidim', 'proposals', 'proposal_m_cell').to_s

module Decidim
  module Proposals
    class ProposalMCell

      delegate :review?, :review_failed?, to: :model

      def has_badge?
        published_state? || withdrawn? || review? || review_failed?
      end

    end
  end
end
