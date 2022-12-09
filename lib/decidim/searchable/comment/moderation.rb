module Decidim
  module Searchable
    module Comment
      class Moderation

        def self.call(query, organization)
          excluded_ids = Decidim::Comments::Comment.in_review.pluck(:id)
          query = query.where.not(resource_id: excluded_ids).where(resource_type: "Decidim::Comments::Comment") if excluded_ids.present?
          query
        end

      end

    end
  end
end