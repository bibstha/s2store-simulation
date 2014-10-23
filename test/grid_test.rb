require_relative 'test_helper'
require 'grid'

class GridTest < MiniTest::Test

  def test_raises_error_on_invalid_num_of_features
    assert_raises(Grid::FeatureCountZero) { Grid.new(0) }
    assert_raises(Grid::FeatureCountZero) { Grid.new(101) }
  end



  def test_grid_hash_has_pre_filled_indices
    grid = Grid.new(1)
    assert_equal SortedSet, grid.cells.fetch(0).class
    assert_equal SortedSet, grid.cells.fetch(9).class
    assert_equal 0, grid.cells.fetch(0).size
    assert_raises(KeyError) { grid.cells.fetch(10) }
  end

  def test_randomize
    grid1 = Grid.new(1)
    grid1.generate_random_cells
    # puts grid1
    assert_in_delta(1, grid1.feature_count, 2)

    grid2 = Grid.new(5)
    grid2.generate_random_cells
    # puts grid2
    assert_in_delta(5, grid2.feature_count, 5)

    grid3 = Grid.new(50)
    grid3.generate_random_cells
    # puts grid3
    assert_in_delta(50, grid3.feature_count, 10)
  end

  def test_large_random_cells
    skip 'Benchmark for randomize'
    require 'benchmark'

    n = 1000
    Benchmark.bm do |x|
      x.report do n.times{ grid = Grid.new(10); grid.generate_random_cells } end
      x.report do n.times{ grid = Grid.new(30); grid.generate_random_cells } end
      x.report do n.times{ grid = Grid.new(50); grid.generate_random_cells } end
      x.report do n.times{ grid = Grid.new(70); grid.generate_random_cells } end
      x.report do n.times{ grid = Grid.new(90); grid.generate_random_cells } end
      x.report do n.times{ grid = Grid.new(99); grid.generate_random_cells } end
    end

  end
end