source 'https://rubygems.org'

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'faker', '~> 3.2'
gem 'rails', '~> 7.1.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

gem 'devise', '~> 4.9'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.4'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'

gem 'ruby-openai', '~> 6.3'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem 'cssbundling-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Localized model attributes
gem 'globalize', '~> 6.3'

gem 'omniauth', '2.1.2'
# Google authentication
gem 'omniauth-google-oauth2'

gem 'omniauth-rails_csrf_protection'

# Static text localization
gem 'rails-i18n'

# Object-oriented Authorization
gem 'pundit', '~> 2.3.1'
gem 'rolify', '~> 6.0'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'google-cloud-storage', '~> 1.48'
gem 'image_processing', '~> 1.12'

group :development, :test do
  gem 'standard'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw windows]
  gem 'dotenv-rails', '~> 2.8'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'letter_opener', '~> 1.8.1'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'shoulda-matchers', '~> 6.0.0'
end

group :test do
  gem 'capybara', '~> 3.39'
  gem 'guard-rspec', '~> 4.7', require: false
  gem 'rackup', '~> 2.1'
  gem 'selenium-webdriver', '~> 4.16'
  gem 'test-prof', '~> 1.2'
  gem 'vcr', github: 'vcr/vcr'
  gem 'webmock'

  gem 'simplecov', require: false
  gem 'stackprof', '~> 0.2.25', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  # annotate models with their corresponding schema
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'next_rails'
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
