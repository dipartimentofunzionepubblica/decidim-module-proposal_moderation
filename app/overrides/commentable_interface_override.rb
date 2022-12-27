# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter escludere commenti in revisione

module Decidim
  module Comments
    module CommentableInterface

      def comments(order_by: nil, single_comment_id: nil)
        SortedComments.for(object, order_by: order_by, id: single_comment_id, current_user: context[:current_user])
      end

    end
  end
end