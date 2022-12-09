module Decidim
  module Searchable
    module Proposal
      class Moderation

        def self.call(query, organization)
          excluded_ids = Decidim::Proposals::Proposal.in_review_accepted.or(Decidim::Proposals::Proposal.in_review).or(Decidim::Proposals::Proposal.in_moderation_rejected).pluck(:id)
          query = query.where.not(resource_id: excluded_ids).where(resource_type: "Decidim::Proposals::Proposal") if excluded_ids.present?
          query
        end

      end

    end
  end
end