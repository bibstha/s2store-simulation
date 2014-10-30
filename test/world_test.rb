require_relative 'test_helper'
require 'world'
require 'benchmark'

module S2Eco
  class WorldTest < MiniTest::Test
    def test_increase_user_population
      skip
      world = World.new
      
      0.upto(DAYS_TOTAL).each do |day|
        world.increase_user_population
        log(
          [day, world.users.count],
          'user_count'
        )
        world.increase_day
      end
      
      puts world.users.first.to_s
    end

    def test_increase_developer_population
      skip
      world = World.new
      0.upto(DAYS_TOTAL).each do |day|
        world.increase_developer_population
        log(
          [day, world.developers.count],
          'developer_count'
        )
        world.increase_day
      end
    end

    def test_simulate
      world = World.new
      world.start
    end
  end
end