# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter rimuovere il button di creazione di un emendamento in review e aggiungere il dettaglio di revisione

# frozen_string_literal: true

module Decidim
  module ProposalModeration
    module AmendmentsHelperOverride
      extend ActiveSupport::Concern

      included do

        def amend_button_for(amendable)
          return if amendable.review_failed?
          return "<div class='card text-center card__amend-button'><div class='card__content'>#{I18n.t('decidim.proposals.proposals.proposal.in_review')}</div></div>".html_safe if current_component.try(:current_settings).try(:moderation_amendment_enabled) && amendable.review?
          return if current_component.try(:current_settings).try(:moderation_amendment_enabled) && amendable.acceptance?
          return unless amendments_enabled? && amendable.amendable?
          return unless current_component.current_settings.amendment_creation_enabled
          return unless can_participate_in_private_space?

          cell("decidim/amendable/amend_button_card", amendable)
        end

      end
    end
  end
end