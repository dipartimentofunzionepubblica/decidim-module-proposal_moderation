# frozen_string_literal: true

require "decidim/proposal_moderation/admin"
require "decidim/proposal_moderation/engine"
require "decidim/proposal_moderation/admin_engine"
require_relative "searchable/comment"
require_relative "searchable/proposal"

module Decidim
  # This namespace holds the logic of the `ProposalModeration` component. This component
  # allows users to create proposal_moderation in a participatory space.
  module ProposalModeration
    autoload :ContentProcessor, "decidim/proposal_moderation/content_processor"
  end
end
