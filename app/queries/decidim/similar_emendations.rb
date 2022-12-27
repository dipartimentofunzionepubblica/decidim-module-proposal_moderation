# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Rimuove gli emendamenti in revisione o rigettati nella verifica dei simili

# frozen_string_literal: true

require_dependency Decidim::Core::Engine.root.join('app', 'queries', 'decidim', 'similar_emendations').to_s

module Decidim
    class SimilarEmendations
      def query
        emendation.class
                  .where(component: component)
                  .only_visible_emendations_for(amender, component)
                  .not_in_moderation_rejected
                  .not_in_review
                  .published
                  .not_hidden
                  .where(
                    "GREATEST(#{title_similarity}, #{body_similarity}) >= ?",
                    translated_attribute(emendation.title),
                    translated_attribute(emendation.body),
                    amendable_module.similarity_threshold
                  )
                  .limit(amendable_module.similarity_limit)
      end
    end
end