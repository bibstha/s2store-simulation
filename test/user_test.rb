require_relative 'test_helper'
require 'user'

module S2Eco
  class UserTest < MiniTest::Test

    def test_initializes_properly
      user = User.new(0)
      user.fill
    end

    def test_days_elapsed
      user = User.new(5)
      days_btw_browse = user.days_btw_browse
    end

  end
end