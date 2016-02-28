source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'

gem 'dotenv-rails'

gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'simple_form'
gem 'kaminari'
gem 'htmlentities'
gem 'gem_patching'

# ElasticSearch
# gem 'elasticsearch-model'
# gem 'elasticsearch-rails'

# Queuing / Backgrounder etc.
gem 'whenever'
gem 'sucker_punch'

# Feed handling
gem 'feedjira'
gem 'feedbag'
gem 'faraday'

# Feed Content handling
gem 'slodown', github: 'hmans/slodown'
gem 'html-pipeline'
gem 'sanitize'
gem 'httparty'

gem 'puma'

group :development, :test do
  gem 'sqlite3'
  gem 'spring'

  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'guard-rspec', require: false
  gem 'capybara'
  gem 'webmock'
end

group :production do
  gem 'mysql2'
end
