# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Creazione evento per poter personalizzare la notifica di pubblicazione emendamento

module Decidim
  module Proposals
    module Admin
      class PublishProposalEvent < Decidim::Events::SimpleEvent

        delegate :url_helpers, to: "Decidim::Core::Engine.routes"

        def resource_text
          resource.body
        end

        def notification_title
          I18n.t("notification_title", i18n_options).html_safe
        end

        def default_i18n_options
          {
            author_name: author_name,
            author_path: author_path,
            author_nickname: author_nickname,
            resource_path: resource_path,
            resource_title: resource_title,
            participatory_space_title: participatory_space_title,
            participatory_space_url: participatory_space_url,
            scope: i18n_scope
          }
        end

        def author
          @author ||= resource.authors.first
        end

        def author_name
          author.name
        end

        def author_path
          url_helpers.profile_path(nickname: author.nickname)
        end

        def author_nickname
          author.nickname
        end

        def resource_path
          manage_component_path(component)
        end

      end
    end
  end
end