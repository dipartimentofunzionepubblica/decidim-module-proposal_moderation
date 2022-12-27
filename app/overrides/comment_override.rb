# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Aggiunge metodo helper al model commento per verificare lo stato, il counter etc

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
