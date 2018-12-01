source 'http://rubygems.org'

gem 'rails', '~> 4.2.11'
gem 'activemodel', '~> 4.2.11'

gem 'rake'

gem 'sqlite3'

group :production do
  gem 'mysql2', '~> 0.3.18'
  # gem 'activerecord-mysql-adapter'
  # gem 'libv8', '3.11.8.3'
  # gem 'therubyracer', '0.11.0beta5', :platform => :ruby
end

gem 'sprockets'
# Gems used only for assets and not required
# in production environments by default.
# group :assets do
gem 'sass-rails', "~> 5.0.3"
gem 'coffee-rails', "~> 4.1.0"
gem 'uglifier', '>=1.3.0'
# end

gem 'jquery-rails', '3.1.3'
gem 'jquery-ui-rails', '5.0.3'

gem 'capistrano', '~> 3.10.0'
gem 'capistrano-rails'
gem 'capistrano-bundler'
gem 'capistrano-passenger', '0.2.0'
gem 'capistrano-rvm'
gem 'capistrano3-puma'

gem "puma"

gem 'thin'

gem 'tinymce-rails'

gem 'offsite_payments', '~> 2.3.0'
gem 'authlogic'#, :git => 'git://github.com/binarylogic/authlogic.git', :ref => '0297e1c005c626c1e37b'
gem 'scrypt', '~> 3.0.6' # Mojave and authlogic require the latest scrypt version.
gem 'bcrypt-ruby'
gem 'cancan'

gem 'acts_as_commentable'
gem 'paperclip', '~> 5.2.0'
gem 'flickraw', '~> 0.9.8'

gem 'paranoia', '~> 2.1.1'

gem 'rspec-rails'
gem 'seed-fu'#, :git => "git://github.com/mbleigh/seed-fu.git", :branch => "rails-3-1"

gem 'exception_notification', '2.6.1'

gem 'whenever', require: false

gem 'multi_json'

group :test do
  # Pretty printed test output
  # gem 'turn', :require => false
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'simplecov', require: false
end
