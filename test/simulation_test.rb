require_relative 'test_helper'
require 'simulation'

class SimulationTest < MiniTest::Test
  def setup
    @sim = Simulation.new
  end

  def test_feature_probability_of_cm
    sim = Simulation.new

    sim.simulation_days = 1
    assert_equal 1, sim.simulation_days
    assert_equal 1.5, sim.p_feat_cm

    sim.simulation_days = 2
    assert_equal 2.0, sim.p_feat_cm

    sim.simulation_days = 99
    assert_equal 50.5, sim.p_feat_cm

    sim.simulation_days = 100
    assert_equal 51, sim.p_feat_cm
  end

  def test_create_cm
    @sim.simulation_days = 10
    cm = @sim.create_cm
    assert_equal 6, cm.cell_count
  end

  def test_create_related_cms
    @sim.simulation_days = 10
    cm = @sim.create_cm
    related_cms = @sim.create_related_cms(cm)

  end
end