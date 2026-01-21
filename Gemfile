# frozen_string_literal: true
ruby File.read('.ruby-version').strip

source 'https://rubygems.org'
gem 'jekyll', '~> 4.3.2'
gem 'nokogiri'
gem 'pry'
gem 'csv'
gem 'base64'
gem 'webrick'

group :jekyll_plugins do
  gem 'jekyll-autoprefixer', git: 'https://github.com/chlorenz/jekyll-autoprefixer.git'
  gem 'jekyll-feed', '~> 0.12'
  gem 'jekyll-figure'
  gem 'jekyll-mastodon_webfinger'
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem 'tzinfo', '~> 1.2'
  gem 'tzinfo-data'
end

# Performance-booster for watching directories on Windows
gem 'wdm', '~> 0.1.1', install_if: Gem.win_platform?
