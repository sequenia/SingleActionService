require 'bundler/setup'
require 'single_action_service'
require 'custom_matchers/have_attr_accessor'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Custom matchers
  config.include HaveAttrAccessor

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
