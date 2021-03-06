require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/.bundle/"
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require "authlogic/test_case"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before(:each) do
    @admin_setting = FactoryGirl.create :admin_setting
  end

  # config.before(:each, :type => :controller) do
  #   Authlogic::Session::Base.controller = (@request && Authlogic::TestCase::ControllerAdapter.new(@request)) || controller
  # end

end

module LoginHelper
  include Authlogic::TestCase

  def login_as(user)
    activate_authlogic
    UserSession.create(user)
  end
end
include LoginHelper

setup_sqlite_db = lambda do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
  load "#{Rails.root.to_s}/db/schema.rb"
end
silence_stream(STDOUT, &setup_sqlite_db)