source 'https://rubygems.org'

gem 'rails', '4.0.4'

gem 'biola_deploy'
gem 'blazing'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'compass-rails'
gem 'declarative_authorization'
gem 'font-awesome-rails'
gem 'humanity', '>= 0.2.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pinglish'
gem 'kaminari-bootstrap', '~> 3.0.1'
# gem 'pretender'
gem 'rack-cas', '>= 0.8.1'
gem 'rails_config'
gem 'sass-rails'
gem 'slim-rails' # for slim generators instead of erb
gem 'therubyracer'
gem 'turnout'
gem 'uglifier'
gem 'version'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'meta_request'  # needed for rails_panel chrome extension https://github.com/dejan/rails_panel
  gem 'terminal-notifier-guard' # sends guard notifications to the OS X Notification Center.
  # gem 'letter_opener'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'pry'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'thin'
end

group :development, :staging, :test do
  gem 'faker'
end

group :development, :staging, :production do
  gem 'newrelic_rpm'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'launchy'
  gem 'rake'   # needed by Travis
  gem 'rspec-html-matchers'
  gem 'shoulda-matchers'
  gem 'spork-rails', '>= 4.0.0'
  # gem 'timecop'

  # For notifications
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
end

group :test, :staging, :production do
  gem 'mysql2'  # needed in test for Travis
end

group :staging, :production do
  gem 'rack-ssl'
end

group :production do
  gem 'exception_notification'
end
