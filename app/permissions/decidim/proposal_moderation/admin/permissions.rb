# frozen_string_literal: true

module Decidim
  module ProposalModeration
    module Admin
      class Permissions < Decidim::DefaultPermissions

        def permissions
          allow! if permission_action.subject == :proposal && permission_action.action == :publish && user.admin?
          allow! if permission_action.subject == :amendment && permission_action.action == :accept && user.admin?

          permission_action
        end
      end
    end
  end
end