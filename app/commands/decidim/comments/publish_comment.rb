# frozen_string_literal: true

module Decidim
  module Comments
    # A command with all the business logic to create a new comment
    class PublishComment < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(comment, user, form)
        @form = form
        @user = user
        @comment = comment
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
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
        NewCommentNotificationCreator.new(comment, mentioned_users, mentioned_groups).create
      end

      def root_commentable(commentable)
        return commentable.root_commentable if commentable.is_a? Decidim::Comments::Comment

        commentable
      end
    end
  end
end
