# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Comando che gestisce la non pubblicazione di una proposta da parte di un admin

# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      class RejectProposal < Rectify::Command

        def initialize(proposal, current_user)
          @proposal = proposal
          @current_user = current_user
        end

        def call
          return broadcast(:invalid) unless current_user&.admin?

          transaction do
            reject_proposal
            find_or_create_moderation!
            update_reported_content!
            create_report!
            hide!
          end

          broadcast(:ok, @proposal)
        end

        def reject_proposal
          title = reset(:title)
          body = reset(:body)

          Decidim.traceability.perform_action!(
            "reject",
            @proposal,
            @current_user,
            visibility: "public-only"
          ) do
            @proposal.update title: title, body: body, published_at: Time.current, state: 'moderation_rejected'
          end
        end

        private

        attr_reader :form, :report

        def find_or_create_moderation!
          @moderation = Moderation.find_or_create_by!(reportable: @proposal, participatory_space: participatory_space, report_count: 1)
        end

        def participatory_space
          @participatory_space ||= @proposal.component&.participatory_space || @proposal.try(:participatory_space)
        end

        def update_reported_content!
          @moderation.update!(reported_content: @proposal.reported_searchable_content_text)
        end

        def create_report!
          @report = Decidim::Report.find_or_initialize_by(
            moderation: @moderation,
            user: @current_user
          ) do |a|
            a.reason = 'admin_rejection'
            a.details = "Proposta non approvata dell'admin #{@current_user.nickname}"
            a.locale = I18n.locale
          end
          @report.save(validate: false)
        end

        def hide!
          Decidim::Admin::HideResource.new(@proposal.reload, @current_user).call
        end

        def reset(attribute)
          attribute_value = @proposal[attribute]
          PaperTrail.request(enabled: false) do
            # rubocop:disable Rails/SkipsModelValidations
            @proposal.update_attribute attribute, ""
            # rubocop:enable Rails/SkipsModelValidations
          end
          attribute_value
        end

        def participatory_space_moderators
          @participatory_space_moderators ||= participatory_space.moderators
        end


      end
    end
  end
end