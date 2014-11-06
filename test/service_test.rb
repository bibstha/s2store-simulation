require_relative 'test_helper'
require 'service'
require 'developer'
require 'user'

module S2Eco
  class ServiceTest < MiniTest::Test

    def test_service_initializes_grid
      service = Service.create
      assert_equal Matrix, service.grid.class

      service2 = Service[1]
      assert_equal service.grid, service2.grid
      assert service2.grid_marshaled
    end

    def test_can_save_service_in_db
      service = Service.new
      service.save

      assert 1, Service.count
    end

    def test_can_have_developer_as_association
      dev = Developer.create(name: "John Doe")
      service = Service.create
      service.developer = dev
      service.save

      assert_equal 1, Developer.count
      assert_equal dev, Developer[1]

      assert_equal dev, Service[service.id].developer
    end

    def test_user_can_save_service
      service = Service.create(name: "Temple Run")
      user = User.create(name: "Baloo")

      assert_equal 0, User[1].services.count
      user.add_service(service)
      
      assert_equal 1, User[1].services.count
      assert_equal service, User[1].services.first
    end

    def test_download_count
      service = Service.create(name: "Temple Run")
      user1 = User.create(name: "Baloo")
      user2 = User.create(name: "Uncle Screwz")

      assert_equal 0, Service[1].download_count
      user1.add_service(service)
      assert_equal 1, Service[1].download_count
      user2.add_service(service)
      assert_equal 2, Service[1].download_count
    end

    def test_is_malicious?
      grid = Matrix.build(10, 10) { false }
      grid[8, 8] = true
      service = Service.new(grid: grid)
      assert service.grid_marshaled
      assert_equal grid, service.grid
      assert_equal false, service.is_malicious?

      grid2 = grid.dup
      grid2[0, 0] = true
      service2 = Service.new(grid: grid2)
      assert service.is_malicious?
    end

    def test_is_buggy?
      grid = Matrix.build(10, 10) { false }
      service = Service.new(grid: grid)
      assert service.grid_marshaled
      assert_equal false, service.is_buggy?

      grid2 = grid.dup
      grid2[9, 9] = true
      service.grid = grid2
      assert service.is_buggy?
    end

    def test_introduce_bug!
      grid = Matrix.build(10, 10) { false }
      service = Service.create(grid: grid)
      
      assert_equal false, service.is_buggy?
      service.introduce_bug!
      assert service.is_buggy?
    end

    def test_fix_bug!
      service = Service.create
      service.introduce_bug!
      assert_equal true,  service.is_buggy?
      service.fix_bug!
      assert_equal false, service.is_buggy?
    end
  end
end