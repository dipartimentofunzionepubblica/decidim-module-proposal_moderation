# Copyright (C) 2022 Formez PA
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

# frozen_string_literal: true

require "decidim/proposal_moderation/admin"
require "decidim/proposal_moderation/engine"
require "decidim/proposal_moderation/admin_engine"
require_relative "searchable/comment"
require_relative "searchable/proposal"
require 'deface'

module Decidim
  # This namespace holds the logic of the `ProposalModeration` component. This component
  # allows users to create proposal_moderation in a participatory space.
  module ProposalModeration
    autoload :ContentProcessor, "decidim/proposal_moderation/content_processor"
  end
end
