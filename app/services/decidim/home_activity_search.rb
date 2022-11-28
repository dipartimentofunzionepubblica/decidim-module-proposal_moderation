require_dependency Decidim::Core::Engine.root.join('app', 'services', 'decidim', 'home_activity_search').to_s

# frozen_string_literal: true

module Decidim

  class HomeActivitySearch

    private

    def all_resources_scope
      query
        .where(
          "(action = ? AND resource_type IN (?)) OR (action = ? AND resource_type IN (?))",
          "publish",
          publicable_resource_types,
          "create",
          (resource_types - publicable_resource_types)
        ).where(
        "(resource_id NOT IN (?) AND resource_type = 'Decidim::Proposals::Proposal')", proposals_in_review_ids
      )
    end

    def proposals_in_review_ids
      Decidim::Proposals::Proposal.in_review.or(Decidim::Proposals::Proposal.in_review_accepted).ids
    end
  end
end
