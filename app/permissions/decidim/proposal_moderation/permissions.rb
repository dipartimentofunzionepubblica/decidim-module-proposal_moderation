# frozen_string_literal: true

module Decidim
  module ProposalModeration
    class Permissions < Decidim::DefaultPermissions

      def permissions
        current_component = context[:current_component]
        permission_action.disallow! if permission_action.subject == :proposal && permission_action.action == :update && current_component.try(:current_settings).try(:moderation_enabled)

        permission_action
      end
    end
  end
end