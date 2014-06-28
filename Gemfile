source 'https://rubygems.org'

ruby '2.1.2'
#ruby-gemset=cmentarz

gem 'rails', '4.1.1'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development

gem 'bootstrap-sass'
gem 'sprockets'
# gem 'bcrypt'
# gem 'faker'
# gem 'will_paginate'
# gem 'bootstrap-will_paginate'
gem 'haml-rails'

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'guard-spring'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
end

group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  gem "launchy"
  gem 'libnotify'
  gem 'shoulda'
  gem 'factory_girl_rails'
end

# Heroku
gem 'rails_12factor', '0.0.2', group: :production
