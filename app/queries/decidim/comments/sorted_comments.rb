require_dependency Decidim::Comments::Engine.root.join('app', 'queries', 'decidim', 'comments', 'sorted_comments').to_s

# frozen_string_literal: true

module Decidim
  module Comments
    class SortedComments

      private

      def base_scope
        r = []
        id = @options[:id]
        r = Comment.where(root_commentable: commentable, id: id) if id.present?

        after = @options[:after]
        if after.present?
          r = Comment.where(root_commentable: commentable).where(
            "decidim_comments_comments.id > ?",
            after
          ) if r.empty?

        end
        r = Comment.where(commentable: commentable) if r.empty?
        if commentable.component.settings.moderation_comments_enabled?
          if @options[:current_user] && commentable.participatory_space.moderators.include?(@options[:current_user])
            return r
          elsif @options[:current_user]
            return r.where.not(id: commentable.comment_threads.map{ |a| a.id if a.review? && a.decidim_author_id != @options[:current_user].id }.compact)
          else
            r.not_in_review
          end
        else
          return r
        end
      end

    end
  end
end
