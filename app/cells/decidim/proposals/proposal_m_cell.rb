# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Override necessario per aggiungere helper method per la visualizzazione all'utente

require_dependency Decidim::Proposals::Engine.root.join('app', 'cells', 'decidim', 'proposals', 'proposal_m_cell').to_s

module Decidim
  module Proposals
    class ProposalMCell

      delegate :review?, :review_failed?, to: :model

      def has_badge?
        published_state? || withdrawn? || review? || review_failed?
      end

    end
  end
end
