source 'https://rubygems.org'

gem 'rails', '4.2.2'
gem 'mysql2'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'sextant'
  gem 'quiet_assets'
  gem 'bullet'
end

group :production do
  gem 'utf8-cleaner'
end

group :test, :development do
  gem 'spring'
  gem 'byebug'
  gem 'web-console', '~> 2.0'

  gem "rspec-rails", "~> 3.0"
  gem "factory_girl_rails", "~> 4.0"
  gem "faker"
  # gem "capybara"
  gem "database_cleaner"
  gem 'rubocop', require: false
  # gem 'poltergeist', '~> 1.6.0'
  gem 'awesome_print'
end

gem 'paranoia', '~> 2.0' # soft delete functional for AR models
