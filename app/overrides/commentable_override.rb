
klasses = ["Decidim::Sortitions::Sortition", "Decidim::Meetings::Meeting", "Decidim::Proposals::Proposal", "Decidim::Budgets::Project", "Decidim::Debates::Debate", "Decidim::Blogs::Post", "Decidim::Comments::Comment"]
klasses.map(&:safe_constantize).compact.each do |klass|
  klass.class_eval do

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