require_relative 'test_helper'
require 'store'
require 'service'
require 'user'

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

    def test_download
      store = Store.new
      users = [User.create, User.create]
      service = Service.create

      assert_equal 0, service.download_count
      store.download(service, users[0])
      store.download(service, users[1])

      assert_equal 2, service.download_count
    end

    def test_top_new_services
      store = Store.new
      [
        Service.new.tap { |s| s.fill },
        Service.new.tap { |s| s.fill },
        Service.new.tap { |s| s.fill },
        Service.new.tap { |s| s.fill }
      ].each do |service|
        store.upload_service(service)
      end.tap do |services|
        assert_equal services, store.top_new_services
      end

      1.upto(60).map { |day| Service.new(day) }.each do |service|
        store.upload_service(service)
      end.tap do |services|
        assert_equal services.reverse[0, 50], store.top_new_services
      end
      
    end
  end
end