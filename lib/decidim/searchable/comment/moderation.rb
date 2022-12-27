# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Convenzione creata: tutte le classi con namespace Decidim::Searchable concorrono per modificare i risultati di ricerca
# In questo caso vengono esclusi dalla ricerca i commenti i revisione

# frozen_string_literal: true

module Decidim
  module Searchable
    module Comment
      class Moderation

        def self.call(query, organization)
          excluded_ids = Decidim::Comments::Comment.in_review.pluck(:id)
          query = query.where.not(resource_id: excluded_ids).where(resource_type: "Decidim::Comments::Comment") if excluded_ids.present?
          query
        end

      end

    end
  end
end