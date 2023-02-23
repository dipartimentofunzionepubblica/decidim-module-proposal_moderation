# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per rimuovere tra le proposte in evidenza (random) eventuali proposte rigettate o in revisione

require_dependency Decidim::Proposals::Engine.root.join('app', 'cells', 'decidim', 'proposals', 'highlighted_proposals_for_component_cell').to_s

module Decidim
  module Proposals
    class HighlightedProposalsForComponentCell

      def proposals
        @proposals ||= Decidim::Proposals::Proposal.published.not_hidden.except_withdrawn
                                                   .where(component: model)
                                                   .not_in_moderation_rejected
                                                   .not_in_review
                                                   .order_randomly(rand * 2 - 1)
      end

    end
  end
end