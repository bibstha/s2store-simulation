require_relative 'test_helper'
require 'developer'
require 'service'

module S2Eco
  class DeveloperTest < Minitest::Test

    def test_can_initialize
      skip
      dev = Developer.create(name: "Random Name")
      assert_equal 0, dev.create_day
      assert_equal true, dev.is_active
      assert_equal [], dev.productive_days
      assert dev.dev_duration >= DEV_MIN && dev.dev_duration <= DEV_MAX

      dev1 = Developer.create(create_day: 5)
      assert_equal 5, dev1.create_day
    end

    def test_can_insert_multiple_developers
      devs = [{create_day: 1}, {create_day: 2}, {create_day: 3}].map { |d| Developer.new(d) }
      Developer.multi_insert(devs)

      assert_equal 3, Developer.count

    end
    
    def test_produce_service
      skip
      dev = Developer.create(create_day: 0, dev_duration: 15)
      service = Service.create

      assert_equal(nil, dev.produce_service(0) { service } )
      assert_equal(nil, dev.produce_service(14) { service } )
      assert_equal(service, dev.produce_service(15){ service } )

      assert_equal(nil, dev.produce_service(16) { service })
      assert_equal(nil, dev.produce_service(29) { service })
      assert_equal(service, dev.produce_service(30) { service })
    end

    def test_service_ready_developers
      skip
      devs = [
        Developer.create(create_day: 0, dev_duration: 15),
        Developer.create(create_day: 0, dev_duration: 14),
        Developer.create(create_day: 0, dev_duration: 16),
        Developer.create(create_day: 2, dev_duration: 13)
      ]

      actual_devs = Developer.service_ready_developers(15)
      assert_equal 2, actual_devs.count
    end

  end
end