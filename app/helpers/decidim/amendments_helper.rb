require_dependency Decidim::Core::Engine.root.join('app', 'helpers', 'decidim', 'amendments_helper').to_s

# frozen_string_literal: true

module Decidim
  module AmendmentsHelper
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
