require_relative 'test_helper'
require 'store'
require 'service'
require 'device'
require 'developer'
require 'context_model'

module S2Eco

  KEY_WRD_MAX = 5

  class StoreTest < MiniTest::Test

    def test_create_service
      store = Store.new

      10.times { Device.create }

      developer = Developer.create
      ap store.create_service(developer: developer, create_day: 0, device_count: 3)
    end

    def test_calculate_system_rankings
      store = Store.new
      10.times { Device.create }
      developer = Developer.create
      
      s1 = store.create_service(developer: developer, create_day: 0, device_count: 3)
      s2 = store.create_service(developer: developer, create_day: 1, device_count: 4)
      s3 = store.create_service(developer: developer, create_day: 1, device_count: 5)
      s3 = store.create_service(developer: developer, create_day: 1, device_count: 5)
      s3 = store.create_service(developer: developer, create_day: 1, device_count: 5)

      ap ContextModel.select_map(:reputation)

    end

  end
end