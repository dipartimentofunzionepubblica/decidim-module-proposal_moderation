# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Esclusione dai risultati di ricerca degli utenti e dei relativi commenti in base ai settings

# frozen_string_literal: true

module Decidim
  class Search

    def call
      search_results = Decidim::Searchable.searchable_resources.inject({}) do |results_by_type, (class_name, klass)|
        custom_filter_namespace = "Decidim::Searchable::#{class_name.demodulize}".safe_constantize
        result_query = filtered_query_for(class_name)
        if custom_filter_namespace
          filter_classes = custom_filter_namespace.constants.select {|c| custom_filter_namespace.const_get(c).is_a? Class}
          filter_classes.each do |filter_class|
            current_klass = "#{custom_filter_namespace}::#{filter_class}".safe_constantize
            result_query = current_klass.call(result_query, organization) if current_klass && current_klass.respond_to?(:call)
          end
          end
        result_ids = result_query.pluck(:resource_id)

        results_count = result_ids.count

        results = if filters[:resource_type].present? && filters[:resource_type] == class_name
                    paginate(klass.order_by_id_list(result_ids))
                  elsif filters[:resource_type].present?
                    ApplicationRecord.none
                  else
                    klass.order_by_id_list(result_ids.take(HIGHLIGHTED_RESULTS_COUNT))
                  end

        results_by_type.update(class_name => {
          count: results_count,
          results: results
        })
      end
      broadcast(:ok, search_results)
    end

  end
end
