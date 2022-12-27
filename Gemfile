# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.25.2"

gem "decidim", DECIDIM_VERSION
gem "decidim-proposal_moderation", path: "."

gem "puma", ">= 5.5"
gem "uglifier", "~> 4.1"
gem "bootsnap"
gem "doorkeeper", "~> 5.5.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
  gem "rspec-rails"
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
  gem "faker", "~> 2.19"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "sqlite3"
  gem "web-console", "~> 3.5"
end

