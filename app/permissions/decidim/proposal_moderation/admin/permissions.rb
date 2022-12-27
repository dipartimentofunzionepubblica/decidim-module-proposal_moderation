# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Aggiunge permessi per pubblicare proposte o emendamenti da parte dell'admin

# frozen_string_literal: true

module Decidim
  module ProposalModeration
    module Admin
      class Permissions < Decidim::DefaultPermissions

        def permissions
          allow! if permission_action.subject == :proposal && permission_action.action == :publish && user.admin?
          allow! if permission_action.subject == :amendment && permission_action.action == :accept && user.admin?

          permission_action
        end
      end
    end
  end
end