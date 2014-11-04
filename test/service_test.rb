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

  end
end