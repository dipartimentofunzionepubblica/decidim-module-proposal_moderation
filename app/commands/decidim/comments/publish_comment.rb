# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce la pubblicazione di un commento

# frozen_string_literal: true

module Decidim
  module Comments
    class PublishComment < Rectify::Command
      def initialize(comment, user, form)
        @form = form
        @user = user
        @comment = comment
      end

      def call
        return broadcast(:invalid) if form.invalid?

        publish_comment

        broadcast(:ok, comment)
      end

      private

      attr_reader :form, :comment

      def publish_comment
        parsed = Decidim::ContentProcessor.parse(comment.body, current_organization: comment.organization)

        mentioned_users = parsed.metadata[:user].users
        mentioned_groups = parsed.metadata[:user_group].groups
        CommentCreation.publish(@comment, parsed.metadata)
        comment.update(state: nil)
        send_notifications(mentioned_users, mentioned_groups)
      end

      def send_notifications(mentioned_users, mentioned_groups)
        NewModerationCommentNotificationCreator.new(comment, mentioned_users, mentioned_groups).create
      end

      def root_commentable(commentable)
        return commentable.root_commentable if commentable.is_a? Decidim::Comments::Comment

        commentable
      end
    end
  end
end
