module Decidim
  module Comments
    module CommentableInterface

      def comments(order_by: nil, single_comment_id: nil)
        SortedComments.for(object, order_by: order_by, id: single_comment_id, current_user: context[:current_user])
      end

    end
  end
end