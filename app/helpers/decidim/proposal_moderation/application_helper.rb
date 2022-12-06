# frozen_string_literal: true

module Decidim
  module ProposalModeration
    # Custom helpers, scoped to the proposal_moderation engine.
    #
    module ApplicationHelper

      def moderation_icon
        content_tag :span, class: 'moderated_user_contents-badge', title: t("moderation_icon", scope: "decidim.admin.helpers"), data: { tooltip: true, "yeti-box": "badges-tooltip" }do
          image_pack_tag 'media/images/moderated_user_contents.png', alt: "Contenuti bloccati"
        end
      end

    end
  end
end
