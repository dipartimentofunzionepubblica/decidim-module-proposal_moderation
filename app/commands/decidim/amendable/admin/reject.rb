# frozen_string_literal: true

module Decidim
  module Amendable
    module Admin
      class Reject < Rectify::Command

        def initialize(resource)
          @amendment = resource.amendment
          @amendable = resource.amendable
          @emendation = resource
          @amender = @emendation.creator_author
          @user_group = @emendation.creator.user_group
        end

        def call
          return broadcast(:invalid) unless @amendment.acceptance? && current_user&.admin?

          transaction do
            reject_emendation
            change_amendment_state_to_review
            find_or_create_moderation!
            update_reported_content!
            hide!
            send_hide_notification_to_moderators
          end

          broadcast(:ok, @emendation)
        end

        def reject_emendation
          Decidim.traceability.perform_action!(
            "reject",
            @emendation,
            @current_user,
            visibility: "public-only"
          ) do
            @emendation.update published_at: Time.current, internal_state: 'moderation_rejected'
          end
        end

        private

        attr_reader :form, :report

        def change_amendment_state_to_review
          # Per aggirare le validazioni in quanto gli STATES sono freezed e falliscono le validazioni
          @amendment.update_column(:state, "moderation_rejected")
        end

        def find_or_create_moderation!
          @moderation = Moderation.find_or_create_by!(reportable: @emendation, participatory_space: participatory_space, report_count: 1)
        end

        def participatory_space
          @participatory_space ||= @emendation.component&.participatory_space || @emendation.try(:participatory_space)
        end

        def update_reported_content!
          @moderation.update!(reported_content: @emendation.reported_searchable_content_text)
        end

        def create_report!
          @report = Decidim::Report.find_or_initialize_by(
            moderation: @moderation,
            user: @current_user
          ) do |a|
            a.reason = 'admin_rejection'
            a.details = "Commento non approvato dell'admin #{@current_user.nickname}"
            a.locale = I18n.locale
          end
          @report.save(validate: false)
        end

        def hide!
          Decidim::Admin::HideResource.new(@emendation.reload, @current_user).call
        end

        def send_hide_notification_to_moderators
          participatory_space_moderators.each do |moderator|
            next unless moderator.email_on_moderations

            ReportedMailer.hide(moderator, @report).deliver_later
          end
        end

        def participatory_space_moderators
          @participatory_space_moderators ||= participatory_space.moderators
        end

      end
    end
  end
end
