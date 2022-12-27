# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per poter escludere emendamenti in revisione o in revisione dell'accettazione

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