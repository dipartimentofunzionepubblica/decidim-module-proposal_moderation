# frozen-string_literal: true

module Decidim
  module Proposals
    module Admin
      class PublishAmendmentEvent < Decidim::Events::SimpleEvent

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
          ResourceLocatorPresenter.new(participatory_space).edit
        end

      end
    end
  end
end