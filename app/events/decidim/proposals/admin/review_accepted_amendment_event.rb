# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# Creazione evento per poter personalizzare la notifica di review emendamento

module Decidim
  module Proposals
    module Admin
      class ReviewAcceptedAmendmentEvent < Decidim::Events::SimpleEvent

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
            resource_path: manage_component_url(component),
            resource_url: manage_component_url(component),
            resource_title: resource_title,
            participatory_space_title: participatory_space_title,
            participatory_space_url: manage_component_url(component),
            scope: i18n_scope
          }
        end

        def author
          @author ||= resource.creator.identity
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

        # Override to backoffice
        def manage_component_url(component)
          current_params = try(:params) || {}
          EngineRouter.admin_proxy(component).root_url(locale: current_params[:locale], "q[state_eq]": 'review_accepted')
        end

        # Override to backoffice
        def resource_path
          manage_component_url(component)
        end

        # Override to backoffice
        def resource_url
          manage_component_url(component)
        end

      end
    end
  end
end