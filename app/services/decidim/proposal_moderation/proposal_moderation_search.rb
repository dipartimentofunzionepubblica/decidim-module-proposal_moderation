# frozen_string_literal: true

module Decidim
  module ProposalModeration
    class ProposalModerationSearch < ::Decidim::Proposals::ProposalSearch
      # def search_state
      #   return query if state.member? "withdrawn"
      #
      #   apply_scopes(%w(accepted rejected review evaluating state_not_published), state)
      # end

    end
  end
end
