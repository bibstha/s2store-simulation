require_relative 'test_helper'
require 'service'

module S2Eco
  class ServiceTest < MiniTest::Test

    def test_service_initializes_grid
      service = Service.new
      assert_equal nil, service.instance_variable_get('@features')

      service.fill
      assert_equal Matrix, service.instance_variable_get('@features').class

      puts service
    end

  end
end