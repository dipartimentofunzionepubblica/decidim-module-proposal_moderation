# frozen_string_literal: true

module Decidim
  module Comments
    class Comment

      scope :in_review, -> { where(published_at: nil, state: "review") }
      scope :not_in_review, -> { where("decidim_comments_comments.state is distinct from 'review'") }

      def review?
        state == "review"
      end

      def update_comments_count
        comments_count = comments.not_hidden.not_deleted.not_in_review.count
        update_columns(comments_count: comments_count, updated_at: Time.current)
      end


    end
  end
end
