require_relative 'test_helper'
require 'grid'

class GridTest < MiniTest::Test

  def setup

  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def grid_hash_has_pre_filled_indices
    grid = Grid.new(1)
    assert_equal [], grid.cells.fetch(0)
    assert_equal [], grid.cells.fetch(9)
    assert_raise(IndexError) { grid.cells.fetch(10) }
  end

  def test_randomize
    grid1 = Grid.new(1)
    grid1.generate_random_cells
    assert_equal(1, grid1.cell_count)

    grid2 = Grid.new(5)
    grid2.generate_random_cells
    assert_equal(5, grid2.cell_count)

    grid3 = Grid.new(50)
    grid3.generate_random_cells
    assert_equal(50, grid3.cell_count)
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