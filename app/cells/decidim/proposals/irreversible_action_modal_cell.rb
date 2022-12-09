require_dependency Decidim::Proposals::Engine.root.join('app', 'cells', 'decidim', 'proposals', 'irreversible_action_modal_cell').to_s

module Decidim
  module Proposals
    class IrreversibleActionModalCell

      delegate :review?, :review_failed?, to: :model

      def modal_title
        if model.component.current_settings.moderation_enabled
          t("title", scope: "decidim.proposals.collaborative_drafts.collaborative_draft.review.irreversible_action_modal")
        else
          t("title", scope: "decidim.proposals.collaborative_drafts.collaborative_draft.#{action}.irreversible_action_modal")
        end

      end

      def modal_body
        if model.component.current_settings.moderation_enabled
          t("body", scope: "decidim.proposals.collaborative_drafts.collaborative_draft.review.irreversible_action_modal")
        else
          t("body", scope: "decidim.proposals.collaborative_drafts.collaborative_draft.#{action}.irreversible_action_modal")
        end
      end

      def button_continue
        if model.component.current_settings.moderation_enabled
          label = t("ok", scope: "decidim.proposals.collaborative_drafts.collaborative_draft.review.irreversible_action_modal")
        else
          label = t("ok", scope: "decidim.proposals.collaborative_drafts.collaborative_draft.#{action}.irreversible_action_modal")
        end

        path = resource_path action
        css = "button expanded"
        button_to label, path, class: css, form_class: "columns medium-6"
      end

      def button_reveal_modal
        data = { open: modal_id }
        if model.component.current_settings.moderation_enabled
          label = t("review", scope: "decidim.proposals.collaborative_drafts.show")
        else
          label = t(action, scope: "decidim.proposals.collaborative_drafts.show")
        end

        css = publish? ? "button expanded button--sc" : "secondary"

        button_tag label, type: "button", class: css, data: data
      end

    end
  end
end
