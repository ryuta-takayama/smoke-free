ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "devise"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

  # Do not auto-load fixtures globally.
  # Tests should load only what they need (e.g., `fixtures :users`).

    # Add more helper methods to be used by all tests here...
  end
end

# Enable Devise helpers in integration tests
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
