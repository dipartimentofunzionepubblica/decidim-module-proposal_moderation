# frozen_string_literal: true

module Decidim
  module ProposalModeration
    class Permissions < Decidim::DefaultPermissions

      def permissions
        current_component = context[:current_component]
        permission_action.disallow! if permission_action.subject == :proposal && permission_action.action == :update && current_component.try(:current_settings).try(:moderation_enabled)
        if permission_action.subject == :comment && permission_action.action == :publish && context[:comment].try(:component).try(:settings).try(:moderation_comments_enabled) && context[:comment].try(:participatory_space).try(:moderators).try(:include?, user)
          permission_action.allow!
        end

        permission_action
      end
    end
  end
end