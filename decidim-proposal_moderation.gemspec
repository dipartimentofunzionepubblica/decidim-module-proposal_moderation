# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/proposal_moderation/version"

Gem::Specification.new do |s|
  s.version = Decidim::ProposalModeration.version
  s.authors = ["Lorenzo Angelone"]
  s.email = ["l.angelone@kapusons.it"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-proposal_moderation"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-proposal_moderation"
  s.summary = "A decidim proposal_moderation module"
  s.description = "The component adds custom moderation for proposals."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::ProposalModeration.version
end
