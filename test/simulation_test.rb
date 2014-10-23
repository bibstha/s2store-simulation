require_relative 'test_helper'
require 'simulation'

class SimulationTest < MiniTest::Test
  def setup
    @sim = Simulation.new
    @cmr = @sim.cmr
  end

  def test_feature_probability_of_cm
    sim = Simulation.new

    sim.simulation_days = 1
    assert_equal 1, sim.simulation_days
    assert_equal 1.99, sim.p_feat_cm

    sim.simulation_days = 2
    assert_equal 2.98, sim.p_feat_cm

    sim.simulation_days = 99
    assert_equal 99.01, sim.p_feat_cm

    sim.simulation_days = 100
    assert_equal 100, sim.p_feat_cm
  end

  def test_create_cm
    @sim.simulation_days = 10
    cm = @sim.create_cm
    assert_in_delta 10, cm.feature_count, 10
  end

  def test_create_related_cms
    @sim.simulation_days = 10
    cm = @sim.create_cm
    related_cms = @sim.create_related_cms(cm)
  end

  def test_possible_related_cms_count
    count = @sim.possible_related_cms_count(1)
    assert_in_delta 1, count, 2

    count = @sim.possible_related_cms_count(10)
    assert_in_delta 10, count, 10
  end

  def test_simulate
    (1..60).each do |day|
      @sim.simulation_days = day
      # assert_equal 20, @sim.cmr.count

      @sim.simulate
      # assert @cmr.count > 20 

      puts "Count: #{@sim.cmr.count}"
      # @sim.cmr[20..-1].each do |cm|
      #   puts cm
      # end
    end
  end
end