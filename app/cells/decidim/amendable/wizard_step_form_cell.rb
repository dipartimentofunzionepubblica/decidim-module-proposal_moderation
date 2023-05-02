# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per personalizzare gli step di creazione di un emendamento

require_dependency Decidim::Core::Engine.root.join('app', 'cells', 'decidim', 'amendable', 'wizard_step_form_cell').to_s

module Decidim
  module Amendable
    class WizardStepFormCell

      delegate :is_review_mode?, to: :controller

      def current_step
        @current_step ||= case params[:action].to_sym
                          when :new, :create
                            1
                          when :compare_draft
                            2
                          when :edit_draft, :update_draft, :destroy_draft
                            3
                          when :preview_draft, :publish_draft
                            moderation_enabled? ? 5 : 4
                          end
      end

      def moderation_enabled?
        is_review_mode?
      end

      def common_options
        {
          view: view,
          current_step: current_step,
          total_steps: 4,
          steps: {
            "1": i18n_step(1),
            "2": i18n_step(2),
            "3": i18n_step(3)
          }.merge(
            moderation_enabled? ? { "5": i18n_step(5) } : { "4": i18n_step(4) }
          )
        }
      end

      def wizard_aside_back_url
        case current_step
        when 1
          Decidim::ResourceLocatorPresenter.new(amendable).path
        when 3
          Decidim::Core::Engine.routes.url_helpers.compare_draft_amend_path(amendment)
        when 4
          Decidim::Core::Engine.routes.url_helpers.edit_draft_amend_path(amendment)
        when 5
          Decidim::Core::Engine.routes.url_helpers.edit_draft_amend_path(amendment)
        end
      end

      def wizard_header_title
        key = case current_step
              when 1
                :new
              when 2
                :compare_draft
              when 3
                :edit_draft
              when 4
                :preview_draft
              when 5
                :review_draft
              end

        t("decidim.amendments.#{key}.title")
      end

    end
  end
end
