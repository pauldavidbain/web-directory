source 'https://rubygems.org'

gem 'rails', '4.0.4'

gem 'api-auth', '~> 1.1.0'
gem 'biola_deploy'
gem 'blazing'
gem 'biola_frontend_toolkit', '~> 0.2.0'
gem 'bootstrap-sass'
gem 'buweb_content_models', '~> 0.24.0'
gem 'coffee-rails'
gem 'compass-rails'
gem 'declarative_authorization'
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'font-awesome-rails'
gem 'httparty', '~> 0.13.0'
gem 'humanity', '>= 0.2.1'
gem 'jquery-rails'
gem 'mongoid', '~> 4.0.0.rc1'
gem 'pinglish'
# gem 'pretender'
gem 'pundit', '~> 0.2.3'
gem 'kaminari-bootstrap', '~> 3.0.1'
gem 'rack-cas', '>= 0.8.1'
gem 'rails_config'
gem 'sass-rails', '>= 4.0.2'
gem 'slim', '>= 2.0.2'
gem 'therubyracer'
gem 'turnout'
gem 'uglifier'
gem 'virtus', '~> 1.0.2'


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'terminal-notifier-guard' # sends guard notifications to the OS X Notification Center.
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'mongoid-rspec'
  gem 'pry'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'thin'
end

group :development, :staging, :test do
  gem 'faker'
end

group :development, :staging, :production do
  gem 'newrelic_rpm'
end

group :test do
  gem 'webmock', '>= 1.17.4'
  # Feel free to add these back later as they are actually needed
  # gem 'capybara'
  # gem 'guard-rspec'
  # gem 'guard-spork'
  # gem 'launchy'
  # gem 'rake'   # needed by Travis
  # gem 'rspec-html-matchers'
  # gem 'shoulda-matchers'
  # gem 'spork-rails', '>= 4.0.0'
  # # gem 'timecop'

  # For notifications
  # gem 'rb-inotify', :require => false
  # gem 'rb-fsevent', :require => false
end

group :staging, :production do
  gem 'rack-ssl'
end

group :production do
  gem 'exception_notification'
end
