source 'https://rubygems.org'
ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '4.2.8'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'rack-attack'

gem 'jquery-rails'
gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'trix', '~> 0.9.9'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'haml', '~> 4.0.7'
gem 'font-awesome-rails'
gem 'paperclip', '~> 4.3'
gem 'aws-sdk', '~> 1.67.0'
gem 'cancancan', '~> 1.10'
gem 'actionmailer_inline_css', '~> 1.6.0'

gem 'active_model_serializers', '~> 0.10.0rc4'
gem 'sidekiq', '~> 4.1.0'
gem 'devise', '~> 3.5.6'
gem 'devise_token_auth', github: 'lockstep/devise_token_auth',
  tag: 'v0.1.38.beta7'
gem 'devise-async'
gem 'omniauth', '~> 1.3.1'
gem 'omniauth-facebook', '~> 4.0.0'
gem 'administrate', '~> 0.4.0'
gem 'kaminari', '~> 0.17'
gem 'sitemap_generator'
gem 'fog-aws'
gem 'mailchimp-api', require: 'mailchimp'
gem 'active_shipping', '~> 2.1.1'

gem 'searchkick', '~> 1.2.1'
gem 'typhoeus'
gem 'airbrake', '~> 5.8'
gem 'newrelic_rpm'
gem 'friendly_id', '~> 5.1.0'

gem 'stripe', '~> 1.36.1'
gem 'slack-notifier'
gem 'country_select'
gem 'searchjoy', '~> 0.2'

group :test do
  gem 'stripe-ruby-mock', require: 'stripe_mock'
  gem 'rack_session_access'
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'database_cleaner'
  gem 'test_after_commit'
  gem 'webmock'
  gem 'sinatra'
end

group :development, :test do
  gem 'pry-rails'
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'capybara', '~> 2.18.0'
  gem 'poltergeist'
  gem 'faker'
end

group :development do
  gem 'letter_opener'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'binding_of_caller'
  gem 'web-console', '~> 2.0'
  gem 'spring', '1.6.4'
  gem 'spring-commands-rspec'
end

group :production do
  gem 'heroku-deflater'
  gem 'rails_12factor'
  gem "rack-timeout"
  gem 'puma'
  gem 'pkg-config', '~> 1.1'
end
