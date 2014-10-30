require_relative 'test_helper'
require 'grid'

module S2Eco
  class GridTest < MiniTest::Test
    def test_to_s_prints_in_array
      grid = Grid.new(0.04)
      grid.fill
      puts grid.to_s
    end
  end
end