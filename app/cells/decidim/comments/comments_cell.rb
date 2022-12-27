# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per personalizzare per rimuovere la visibilitò dei commenti da revisionare

# frozen_string_literal: true

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