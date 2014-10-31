require_relative 'test_helper'
require 'user'

module S2Eco
  class UserTest < MiniTest::Test

    def test_initializes_properly
      
      50.times do
        0.upto(U_AVOID_SIZE - 1) do |row|
          0.upto(U_AVOID_SIZE - 1) do |col|
            user = User.new(0)
            user.fill
            assert_equal false, user.features[row, col]
          end
        end
      end

    end

    def test_days_elapsed
      user = User.new(5)
      days_btw_browse = user.days_btw_browse
    end

  end
end