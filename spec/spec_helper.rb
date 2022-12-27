# frozen_string_literal: true

require "decidim/dev"

ENV["ENGINE_ROOT"] = File.dirname(__dir__)

Decidim::Dev.dummy_app_path = File.expand_path(File.join(".", "spec", "decidim_dummy_app"))

require "decidim/dev/test/base_spec_helper"
require "decidim/proposals/test/factories"
require "decidim/proposals"
require "customization_factories"

RSpec.configure do |config|
  config.full_backtrace = true
  # config.include Decidim::ProposalModeration::ApplicationHelper
  # config.before :each, type: :request do
  #   helper.class.include Decidim::ProposalModeration::AdminEngine.routes.url_helpers
  # end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end