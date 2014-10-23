class Grid

  GRID_SIZE = 10

  def initialize(feature_count)
    @feature_count = feature_count
  end

  def generate_random_cells
    (1..feature_count).each do |feature_x|
      x = rand(GRID_SIZE)
      y = rand(GRID_SIZE)
      redo if cells[x].include?(y)
      cells[x] << y
    end
  end

  def feature_count
    @feature_count
  end

  def cells
    @cells ||= (0..(GRID_SIZE-1)).inject({}) do |accum, i|
       accum[i] = []
       accum
    end
  end

  def cell_count
    cells.map do |index, arr|
      arr.size
    end.inject(:+)
  end

  def pointed_by
    @pointed_by ||= []
  end

  def points_to
    @points_to ||= []
  end

end