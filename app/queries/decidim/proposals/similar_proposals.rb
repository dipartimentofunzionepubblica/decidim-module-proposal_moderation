# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Rimuove le proposte in revisione o rigettate nella verifica dei simili

# frozen_string_literal: true

require_dependency Decidim::Proposals::Engine.root.join('app', 'queries', 'decidim', 'proposals', 'similar_proposals').to_s

module Decidim
  module Proposals
      class SimilarProposals

        def query
          Decidim::Proposals::Proposal
            .where(component: @components)
            .published
            .not_in_moderation_rejected
            .not_in_review
            .not_hidden
            .where(
              "GREATEST(#{title_similarity}, #{body_similarity}) >= ?",
              *similarity_params,
              Decidim::Proposals.similarity_threshold
            )
            .limit(Decidim::Proposals.similarity_limit)
        end

      end
  end
end