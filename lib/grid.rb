require 'set'
require 'alias'

class Grid

  attr_accessor :name

  GRID_SIZE = 10

  def initialize(num_of_features)
    if num_of_features < 1 || num_of_features > 100
      raise FeatureCountZero, "Feature count should be between [1, 100] inclusive, #{num_of_features} given"
    end
    @num_of_features = num_of_features
  end

  def generate_random_cells
    p_values =  [@num_of_features/100.0, 1-@num_of_features/100.0]
    cell_picker = AliasTable.new([true, false], p_values)
    begin
      (0..9).each do |x|
        (0..9).each do |y|
          cells[x] << y if cell_picker.generate
        end
      end
    end until feature_count > 0 # no empty grid
  end

  def cells
    @cells ||= (0..(GRID_SIZE-1)).inject({}) do |accum, i|
       accum[i] = SortedSet.new
       accum
    end
  end

  def feature_count
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

  def uses(grid)
    outgoing << grid
    grid.incoming << self
  end

  def outgoing
    @outgoing ||= Set.new
  end

  def incoming
    @incoming ||= Set.new
  end

  def to_s
    puts "Name: #{name}, Points to: #{outgoing.count}, Used by #{incoming.count}"
    cells.each do |index, array|
      puts "#{index}: " << array.to_a.join(" ")
    end
  end

  FeatureCountZero = Class.new(StandardError)

end

