source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'therubyracer'

# Deploy with Capistrano
# gem 'capistrano'

gem 'thin'

gem 'heroku'

gem 'activemerchant'
gem 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git', :ref => '0297e1c005c626c1e37b'
gem 'bcrypt-ruby'

gem 'rspec-rails'
gem 'seed-fu', :git => "git://github.com/mbleigh/seed-fu.git", :branch => "rails-3-1"


group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'factory_girl_rails'
  gem 'timecop'
end
