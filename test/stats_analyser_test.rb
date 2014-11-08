require_relative 'test_helper'
require 'world'
require 'stats_analyser'

module S2Eco
  class StatsAnalyserTest < MiniTest::Test
    def test_daily_analysis_on

      world = World.new
      store = Store.new
      10.times { Device.create }
      developer = Developer.create
      
      s1 = store.create_service(developer: developer, create_day: 0, device_count: 3)
      s2 = store.create_service(developer: developer, create_day: 1, device_count: 4)
      s3 = store.create_service(developer: developer, create_day: 1, device_count: 5)
      s3 = store.create_service(developer: developer, create_day: 1, device_count: 5)
      s3 = store.create_service(developer: developer, create_day: 1, device_count: 5)

      ap ContextModel.select_map(:reputation)

      analyser = StatsAnalyser.new(store, world)
      analyser.daily_analysis_on(1)

    end
  end
end
