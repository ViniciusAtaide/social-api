require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
require 'support/factory_bot'
require 'rspec/collection_matchers'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  config.include RequestSpecHelper

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |file|
    DatabaseCleaner.cleaning do
      file.run
    end
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
