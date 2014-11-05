require_relative 'test_helper'
require 'world'
require 'stats_analyser'

module S2Eco
  class StatsAnalyserTest < MiniTest::Test

    def test_daily_analysis_on
      store = Store.new
      world = World.new
      sa = StatsAnalyser.new(store, world)

      service1 = Service.create
      service2 = Service.create

      u1 = User.create
      u2 = User.create
      u3 = User.create
      u4 = User.create
      u5 = User.create
      u6 = User.create

      Download.create(user: u1, service: service1)
      Download.create(user: u2, service: service1, vote: 1)
      Download.create(user: u3, service: service1, vote: 2)
      Download.create(user: u4, service: service1, vote: 3)
      Download.create(user: u5, service: service1, vote: 4)
      # Download.create(user: u6, service: service1, vote: 5)
      Download.create(user: u2, service: service2, vote: 5)

      average_votes = sa.daily_analysis_on(5).map{ |dl| [dl[:service_id], dl[:vote]] }.to_h
      assert_equal({1 => 3.0, 2 => 5.0}, average_votes)
    end

  end
end
