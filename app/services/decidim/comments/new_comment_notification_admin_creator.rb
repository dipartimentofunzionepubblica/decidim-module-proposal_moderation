# frozen_string_literal: true

module Decidim
  module Comments
    # This class handles what events must be triggered, and to what users,
    # after a comment is created. Handles these cases:
    #
    # - A user is mentioned in the comment
    # - My comment is replied
    # - A user I'm following has created a comment/reply
    # - A new comment has been created on a resource, and I should be notified.
    #
    # A given user will only receive one of these notifications, for a given
    # comment. The comment author will never be notified about their own comment.
    # If need be, the code to handle this cases can be swapped easily.
    class NewCommentNotificationAdminCreator
      # comment - the Comment from which to generate notifications.
      # mentioned_users - An ActiveRecord::Relation of the users that have been
      #   mentioned
      # mentioned_groups - And ActiveRecord::Relation of the user_groups that have
      #   been mentioned
      def initialize(comment, mentioned_users, mentioned_groups = nil)
        @comment = comment
        @mentioned_users = mentioned_users
        @mentioned_groups = mentioned_groups
        @already_notified_users = [comment.author]
      end

      # Generates the notifications for the given comment.
      #
      # Returns nothing.
      def create
        notify_admins
      end

      private

      attr_reader :comment, :mentioned_users, :mentioned_groups, :already_notified_users

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
            comment_id: comment.id
          }
        }.deep_merge(users)

        Decidim::EventsManager.publish(data)
      end
    end
  end
end
