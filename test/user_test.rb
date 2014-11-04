require_relative 'test_helper'
require 'user'
require 'service'
require 'download'

module S2Eco
  class UserTest < MiniTest::Test
    def test_initialize
      user = User.create(days_btw_browse: 50)
      assert_equal Matrix, user.grid.class

      actual_user = User[1]
      assert_equal Matrix, actual_user.grid.class
      assert_equal user.grid, actual_user.grid

      assert_equal 50, actual_user.days_btw_browse
      assert_equal 0,  actual_user.create_day
      assert actual_user.last_browse_day >= -50 && actual_user.last_browse_day <= 0

      user2 = User.create(create_day: 25, days_btw_browse: 40)
      actual_user2 = User[2]

      assert_equal 40, actual_user2.days_btw_browse
      assert_equal 25,  actual_user2.create_day
      assert actual_user2.last_browse_day >= -15 && actual_user2.last_browse_day <= 25
    end

    def test_grid_initializes_properly
      # 50.times do
      #   0.upto(U_AVOID_SIZE - 1) do |row|
      #     0.upto(U_AVOID_SIZE - 1) do |col|
      #       user = User.new(0)
      #       user.fill
      #       assert_equal false, user.features[row, col]
      #     end
      #   end
      # end
    end

    def test_ready_to_browse_on
      users = [
        User.create(create_day: 10, days_btw_browse: 20, last_browse_day: 10),
        User.create(create_day: 11, days_btw_browse: 21, last_browse_day: 10),
        User.create(create_day: 12, days_btw_browse: 15, last_browse_day: 15),
        User.create(create_day: 13, days_btw_browse: 22, last_browse_day: 10),
        User.create(create_day: 14, days_btw_browse: 10, last_browse_day: 20)
      ]

      assert_equal 5, User.count
      ready_users = User.ready_to_browse_on(30)
      assert_equal 3, ready_users.count

      assert_equal users[0], ready_users.all[0]
      assert_equal users[2], ready_users.all[1]
      assert_equal users[4], ready_users.all[2]    
    end

    def test_interested_services
      user = User.create
      user.grid = Matrix[ [true, false], [false, true] ]
      
      services = [
        Service.create.tap { |s| s.grid = Matrix[ [true, true], [true, true] ] },
        Service.create.tap { |s| s.grid = Matrix[ [false, true], [false, false] ] },
        Service.create.tap { |s| s.grid = Matrix[ [true, false], [false, false] ] },
        Service.create.tap { |s| s.grid = Matrix[ [false, false], [false, true] ] }
      ]
      
      user.select_interested_services(services).tap do |i_s|
        assert_equal 2, i_s.count
        assert_equal services[2], i_s[0]
        assert_equal services[3], i_s[1]
      end

      user.add_service(services[2])
      user.select_interested_services(services).tap do |i_s|
        assert_equal 1, i_s.count
        assert_equal services[3], i_s[0]
      end
    end

    def test_downloads
      user = User.create
      services = [
        Service.create,
        Service.create,
        Service.create,
        Service.create
      ]
      services.each { |s| user.add_service(s) }
      assert_equal 4, user.downloads.count
    end

    def test_unvoted_services
      user = User.create
      services = [
        Service.create,
        Service.create,
        Service.create,
        Service.create
      ]
      services.each { |s| user.add_service(s) }

      user.unvoted_services.each do |unvoted_service|
        services.include? unvoted_service
      end
    end
  end
end