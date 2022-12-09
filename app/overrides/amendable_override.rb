module Decidim
  module Amendable

    def visible_emendations_for(user)
      published_emendations = emendations.published
      if component.current_settings.moderation_amendment_enabled
        published_emendations = emendations.not_in_moderation_rejected.not_in_review.or(emendations.in_moderation_rejected_for_user(user).or(emendations.in_review_for_user(user)))
        published_emendations = published_emendations.where.not(state: 'review_accepted') unless emendations.published.map(&:authors).flatten.include?(user)
      end
      return published_emendations unless component.settings.amendments_enabled

      case component.current_settings.amendments_visibility
      when "participants"
        return self.class.none unless user

        published_emendations.where(decidim_amendments: { decidim_user_id: user.id })
      else # Assume 'all'
        published_emendations
      end
    end

  end
end