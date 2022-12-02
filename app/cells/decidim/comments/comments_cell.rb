require_dependency Decidim::Comments::Engine.root.join('app', 'cells', 'decidim', 'comments', 'comments_cell').to_s

module Decidim
  module Comments
    class CommentsCell

      def comments
        if single_comment?
          [single_comment]
        else
          SortedComments.for(model, order_by: order, current_user: current_user)
        end
      end

    end
  end
end