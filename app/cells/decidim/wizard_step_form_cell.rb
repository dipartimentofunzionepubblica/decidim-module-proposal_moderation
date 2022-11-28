require_dependency Decidim::Core::Engine.root.join('app', 'cells', 'decidim', 'wizard_step_form_cell').to_s

module Decidim
  class WizardStepFormCell

    def current_steps
      view_options[:steps].keys.map(&:to_s).map(&:to_i)
    end

    def wizard_stepper
      content_tag :ol, class: "wizard__steps" do
        current_steps.map { |step| wizard_stepper_step(step) }.join
      end
    end
  end
end