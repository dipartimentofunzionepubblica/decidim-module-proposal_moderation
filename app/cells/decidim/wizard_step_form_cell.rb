# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per personalizzare gli step per la creazione di una proposta in caso moderazione proposta abilitata

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