require_relative 'test_helper'
require 'developer'

module S2Eco
  class DeveloperTest < Minitest::Test

    def test_can_initialize
      dev = Developer.new
      assert_equal 0, dev.start_day
      assert_equal true, dev.is_active?
      assert_equal [], dev.productive_days
      assert dev.dev_duration >= DEV_MIN && dev.dev_duration <= DEV_MAX
    end
    
  end
end