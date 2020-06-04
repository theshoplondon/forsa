source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '>= 6.0.3.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 4.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'

gem 'foundation-rails'
gem 'autoprefixer-rails'

gem 'wicked'
gem 'gibbon'
gem 'sucker_punch'

gem 'devise'
gem 'kaminari'
gem 'tiddle'
gem 'rollbar'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Gems with generators that need to remain accessible go here
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  # Gems needed in development and on CI
  gem 'dotenv-rails'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'rspec_junit_formatter'
  gem 'vcr'
  gem 'webmock'
  gem 'rubocop'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
