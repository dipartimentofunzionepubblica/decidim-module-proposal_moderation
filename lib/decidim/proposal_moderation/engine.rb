# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ProposalModeration
    # This is the engine that runs on the public interface of proposal_moderation.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ProposalModeration

      routes do
        # Add engine routes here
        # resources :proposal_moderation
        # root to: "proposal_moderation#index"
      end

      initializer "ProposalModeration.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
