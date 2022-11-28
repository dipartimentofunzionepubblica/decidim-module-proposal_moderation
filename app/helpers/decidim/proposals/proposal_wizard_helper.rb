require_dependency Decidim::Proposals::Engine.root.join('app', 'helpers', 'decidim', 'proposals', 'proposal_wizard_helper').to_s


# frozen_string_literal: true

module Decidim
  module Proposals
    # Simple helpers to handle markup variations for proposal wizard partials
    module ProposalWizardHelper

      def proposal_wizard_stepper(current_step)

        content_tag :ol, class: "wizard__steps" do
          %(
          #{proposal_wizard_stepper_step(:step_1, current_step)}
          #{proposal_wizard_stepper_step(:step_2, current_step)}
          #{proposal_wizard_stepper_step(:step_3, current_step)}
          #{proposal_wizard_stepper_step(current_component.current_settings.try(:moderation_enabled) ? :step_5 : :step_4, current_step)}
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
