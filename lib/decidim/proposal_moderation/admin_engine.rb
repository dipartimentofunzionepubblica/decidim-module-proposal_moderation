# frozen_string_literal: true

module Decidim
  module ProposalModeration
    # This is the engine that runs on the public interface of `ProposalModeration`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::ProposalModeration::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :proposal_moderation do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "proposal_moderation#index"
      end

      def load_seed
        nil
      end
    end
  end
end
