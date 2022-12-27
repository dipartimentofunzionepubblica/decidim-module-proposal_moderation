# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Modulo che aggiunge in nuovi stati nei filtri di backoffice

# frozen_string_literal: true

module Decidim
  module Proposals
    module Admin
      module FilterableOverrides
        extend ActiveSupport::Concern

        included do
          private

          def proposal_states
            Proposal::POSSIBLE_STATES.without("not_answered") + ["review", "review_accepted", "moderation_rejected"]
          end

        end

      end
    end
  end
end