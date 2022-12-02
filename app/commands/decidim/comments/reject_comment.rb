# frozen_string_literal: true

module Decidim
  module Comments
    # A command with all the business logic to create a new comment
    class RejectComment < Rectify::Command
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

        transaction do
          find_or_create_moderation!
          update_reported_content!
          create_report!
          hide!
          send_hide_notification_to_moderators
        end

        broadcast(:ok, comment)
      end

      private

      attr_reader :form, :report

      def find_or_create_moderation!
        @moderation = Decidim::Moderation.find_or_create_by!(reportable: @comment, participatory_space: participatory_space)
      end

      def update_reported_content!
        @moderation.update!(reported_content: @comment.reported_searchable_content_text, report_count: @moderation.report_count + 1 )
      end

      def participatory_space
        @participatory_space ||= @comment.component&.participatory_space || @comment.try(:participatory_space)
      end

      def create_report!
        @report = Decidim::Report.find_or_initialize_by(
          moderation: @moderation,
          user: @user
        ) do |a|
          a.reason = 'admin_rejection'
          a.details = "Commento non approvato dell'admin #{@user.nickname}"
          a.locale = I18n.locale
        end
        @report.save(validate: false)
      end

      def hide!
        Decidim::Admin::HideResource.new(@comment, @user).call
      end

      def participatory_space_moderators
        @participatory_space_moderators ||= participatory_space.moderators
      end

      def send_hide_notification_to_moderators
        participatory_space_moderators.each do |moderator|
          next unless moderator.email_on_moderations

          ReportedMailer.hide(moderator, @report).deliver_later
        end
      end


    end
  end
end
