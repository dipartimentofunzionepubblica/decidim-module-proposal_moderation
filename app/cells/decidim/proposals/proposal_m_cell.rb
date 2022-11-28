require_dependency Decidim::Proposals::Engine.root.join('app', 'cells', 'decidim', 'proposals', 'proposal_m_cell').to_s

module Decidim
  module Proposals
    class ProposalMCell

      delegate :review?, to: :model

      def has_badge?
        published_state? || withdrawn? || review?
      end

    end
  end
end
