# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override metodo per il conteggio dei commenti

# frozen_string_literal: true

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