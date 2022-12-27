# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Aggiunge permessi per pubblicare commenti da parte dell'admin e rimuove la possibilitò di modifica di una proposta

# frozen_string_literal: true

module Decidim
  module ProposalModeration
    class Permissions < Decidim::DefaultPermissions

      def permissions
        current_component = context[:current_component]
        permission_action.disallow! if permission_action.subject == :proposal && permission_action.action == :update && current_component.try(:current_settings).try(:moderation_enabled)
        if permission_action.subject == :comment && permission_action.action == :publish && context[:comment].try(:component).try(:settings).try(:moderation_comments_enabled) && context[:comment].try(:participatory_space).try(:moderators).try(:include?, user)
          permission_action.allow!
        end

        permission_action
      end
    end
  end
end