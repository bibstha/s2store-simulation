require_relative 'test_helper'
require 'store'
require 'service'

module S2Eco

  KEY_WRD_MAX = 5

  class StoreTest < MiniTest::Test

    def test_keyword_search_services
      store = Store.new
      15.times do
        store.upload_service(Service.new.tap { |s| s.fill })
      end

      50.times do
        services = store.keyword_search_services
        assert services.count <= 5
        assert services.count >= 1
      end
    end

  end
end