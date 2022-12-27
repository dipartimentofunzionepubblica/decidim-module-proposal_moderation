# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Crea lo notifica agli admin quando viene creato un nuovo commento

# frozen_string_literal: true

module Decidim
  module Comments
    class NewCommentNotificationAdminCreator
      def initialize(comment, priority = :low)
        @comment = comment
        @already_notified_users = [comment.author]
        @priority = priority
      end

      def create
        notify_admins
      end

      private

      attr_reader :comment, :already_notified_users

      def notify_admins
        notify(:admin, affected_users: @comment.participatory_space.moderators)
      end

      def notify(event, users)
        return if users.values.flatten.blank?

        event_class = "Decidim::Comments::#{event.to_s.camelcase}Event".constantize
        data = {
          event: "decidim.events.comments.#{event}",
          event_class: event_class,
          resource: comment.root_commentable,
          extra: {
            comment_id: comment.id,
            priority: @priority
          }
        }.deep_merge(users)

        Decidim::EventsManager.publish(data)
      end
    end
  end
end
