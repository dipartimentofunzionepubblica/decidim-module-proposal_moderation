# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter personalizzare la form di creazione di proposta con il nuovo flusso

# frozen_string_literal: true

module Decidim
  module ProposalModeration
    module ProposalWizardHelperOverride

      extend ActiveSupport::Concern

      included do

        def proposal_wizard_stepper(current_step)

          content_tag :ol, class: "wizard__steps" do
            %(
            #{proposal_wizard_stepper_step(:step_1, current_step)}
            #{proposal_wizard_stepper_step(:step_2, current_step)}
            #{proposal_wizard_stepper_step(:step_3, current_step)}
            #{proposal_wizard_stepper_step(is_review_mode? ? :step_5 : :step_4, current_step)}
            ).html_safe
          end
        end

        def proposal_wizard_aside_link_to_back(step)
          case step
          when :step_1
            proposals_path
          when :step_3
            compare_proposal_path
          when :step_4
            edit_draft_proposal_path
          when :step_5
            edit_draft_proposal_path
          end
        end

        def proposal_wizard_step_number(step)
          current_step = step.to_s.split("_").last.to_i
          current_step == 5 ? 4 : current_step
        end

        def proposal_wizard_step_title(action_name)
          step_title = case action_name
                       when "create"
                         "new"
                       when "update_draft"
                         "edit_draft"
                       else
                         @step == :step_5 ? "review" : action_name
                       end

          t("decidim.proposals.proposals.#{step_title}.title")
        end

        def proposal_complete_state(proposal)
          return humanize_proposal_state(proposal.internal_state).html_safe if proposal.answered? && !proposal.published_state?

          humanize_proposal_state(proposal.review? ? proposal.internal_state : proposal.state).html_safe
        end

      end
    end
  end
end

