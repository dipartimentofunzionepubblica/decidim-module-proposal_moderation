module Decidim
  module Proposals
    module Admin
      module FilterableOverrides
        extend ActiveSupport::Concern

        included do
          private

          def proposal_states
            Proposal::POSSIBLE_STATES.without("not_answered") + ["review", "review_accepted", "moderation_rejected"]
          end

        end

      end
    end
  end
end