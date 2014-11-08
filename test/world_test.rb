require_relative 'test_helper'
require 'world'
require 'benchmark'

reset_logs(["device_population_increase", "developer_population_increase"])

module S2Eco
  class WorldTest < MiniTest::Test
    
    def test_pop_t_devices_increase
      
      world = World.new

      DAYS_TOTAL.times do
        population = world.pop_t_devices
        log([world.current_day, population], "device_population_increase")
        world.increase_day
      end
    end

    def test_pop_t_dev_increase
      world = World.new

      DAYS_TOTAL.times do
        population = world.pop_t_dev
        log([world.current_day, population], "developer_population_increase")
        world.increase_day
      end
    end        

  end
end