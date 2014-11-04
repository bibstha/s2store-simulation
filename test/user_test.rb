require_relative 'test_helper'
require 'user'
require 'service'

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

    def test_interested_services
      user = User.new(1)
      user.features = Matrix[ [true, false], [false, true] ]
      
      services = [
        Service.new.tap { |s| s.features = Matrix[ [true, true], [true, true] ] },
        Service.new.tap { |s| s.features = Matrix[ [false, true], [false, false] ] },
        Service.new.tap { |s| s.features = Matrix[ [true, false], [false, false] ] },
        Service.new.tap { |s| s.features = Matrix[ [false, false], [false, true] ] }
      ]
      user.select_interested_services(services).tap do |i_s|
        assert_equal 2, i_s.count
        assert_equal services[2], i_s[0]
        assert_equal services[3], i_s[1]
      end
    end

    def test_install_service
      user = User.new(1)
      services = [ Service.new, Service.new, Service.new ]

      services.each do |s|
        user.install_service(s)
      end

      services.each do |s|
        assert user.service_installed?(s)
      end

      assert_equal false, user.service_installed?(Service.new)
    end

  end
end