# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Crea lo notifica agli autori e alle eventuali citazioni quando viene pubblicato un nuovo commento

# frozen_string_literal: true

module Decidim
  module Comments
    class NewModerationCommentNotificationCreator < NewCommentNotificationCreator

      def create
        notify_mentioned_users
        notify_mentioned_groups
        notify_parent_comment_author
        notify_author
        notify_author_followers
        notify_user_group_followers
        notify_commentable_recipients
      end

      def notify_author
        notify(:published_comment, affected_users: [comment.author])
      end

    end
  end
end