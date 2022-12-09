require_dependency Decidim::Proposals::Engine.root.join('app', 'queries', 'decidim', 'proposals', 'similar_proposals').to_s

# frozen_string_literal: true

module Decidim
  module Proposals
      class SimilarProposals

        def query
          Decidim::Proposals::Proposal
            .where(component: @components)
            .published
            .not_in_moderation_rejected
            .not_in_review
            .not_hidden
            .where(
              "GREATEST(#{title_similarity}, #{body_similarity}) >= ?",
              *similarity_params,
              Decidim::Proposals.similarity_threshold
            )
            .limit(Decidim::Proposals.similarity_limit)
        end

      end
  end
end