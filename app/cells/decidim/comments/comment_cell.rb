# frozen_string_literal: true

require_dependency Decidim::Comments::Engine.root.join('app', 'cells', 'decidim', 'comments', 'comment_cell').to_s

module Decidim
  module Comments
    class CommentCell

      def replies
        SortedComments.for(model, order_by: order, current_user: current_user)
      end

      def has_replies?
        if (current_user && current_participatory_space.moderators.include?(current_user)) || !model.component.settings.moderation_comments_enabled?
          model.comment_threads.any?
        else
          model.comment_threads.map{ |a| a.id if !a.review? || (a.review? && a.decidim_author_id == current_user.try(:id)) }.compact.any?
        end
      end

      def current_participatory_space
        model.participatory_space
      end

    end
  end
end
