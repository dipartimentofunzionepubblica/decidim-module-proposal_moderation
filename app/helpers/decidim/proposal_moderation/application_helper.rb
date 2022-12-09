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

      def get_moderation_action_url(proposal, action)
        case current_participatory_space
        when Decidim::Assembly then decidim_proposals_admin.send("#{action}_assembly_proposal_admin_path", current_participatory_space, current_component, proposal)
        when Decidim::ParticipatoryProcess then decidim_proposals_admin.send("#{action}_process_proposal_admin_path", current_participatory_space, current_component, proposal)
        else
          decidim_proposals_admin.send("#{action}_conference_proposal_admin_path", current_participatory_space, current_component, proposal)
        end
      end

    end
  end
end
