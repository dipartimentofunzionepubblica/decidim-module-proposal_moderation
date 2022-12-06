# frozen-string_literal: true

module Decidim
  module Comments
    class AdminEvent < Decidim::Events::SimpleEvent
      include Decidim::Comments::CommentEvent

      i18n_attributes :priority

      def priority
        I18n.t("decidim.events.comments.admin.priority_#{extra["priority"]}")
      end
    end
  end
end
