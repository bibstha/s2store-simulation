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

    def test_top_best_services
      skip
      store = Store.new
      store.current_day = 1

      services = 20.times.map { Service.create }
      users = 5.times.map { User.create }

      store.download(services[0], users[0])
      store.download(services[1], users[0])

      store.current_day = 2
      store.download(services[1], users[1])
      store.download(services[1], users[2])
      store.download(services[2], users[1])
      store.download(services[3], users[1])
      

      store.current_day = 3
      store.download(services[2], users[2])
      store.download(services[3], users[2])
      store.download(services[4], users[2])
      store.download(services[5], users[2])

      store.current_day = 4
      # 8*D1 + 5*D2 + 5*D3 + 3*D4
      # S0 = 0 + 0 + 5 + 0 = 5
      # S1 = 0 + 10 + 5 + 0 = 15
      # S2 = 8 + 5 = 13
      # S3 = 8 + 5 = 13
      # S4 = 8
      # S5 = 8

      best_services = store.top_best_services

      assert_equal services[1], best_services[0]
      assert_equal services[2], best_services[1]
      assert_equal services[3], best_services[2]
      assert_equal services[4], best_services[3]
      assert_equal services[5], best_services[4]
      assert_equal services[0], best_services[5]
    end

  end
end