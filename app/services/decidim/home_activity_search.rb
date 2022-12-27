# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Rimuove elementi in revisione nelle ultime attività in home

# frozen_string_literal: true

require_dependency Decidim::Core::Engine.root.join('app', 'services', 'decidim', 'home_activity_search').to_s

module Decidim

  class HomeActivitySearch

    private

    def all_resources_scope
      query
        .where(
          "(action = ? AND resource_type IN (?)) OR (action = ? AND resource_type IN (?))",
          "publish",
          publicable_resource_types,
          "create",
          (resource_types - publicable_resource_types)
        ).where(
        "(resource_id NOT IN (?) AND resource_type = 'Decidim::Proposals::Proposal')", proposals_in_review_ids
      )
    end

    def proposals_in_review_ids
      Decidim::Proposals::Proposal.in_review.or(Decidim::Proposals::Proposal.in_review_accepted).ids
    end
  end
end
