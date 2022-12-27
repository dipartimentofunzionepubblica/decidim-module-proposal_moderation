
module Decidim
  module ProposalModeration
    module CommentableOverride
      extend ActiveSupport::Concern

      included do
        def update_comments_count
          if self.component.settings.moderation_comments_enabled?
            comments_count = comments.not_hidden.not_deleted.not_in_review.count
            update_columns(comments_count: comments_count, updated_at: Time.current)
          else
            comments_count = comments.not_hidden.not_deleted.count
            update_columns(comments_count: comments_count, updated_at: Time.current)
          end
        end
      end
    end
  end
end