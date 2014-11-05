require 'matrix'
require 'alias'

module S2Eco
  module Grid

    def generate_grid
      Matrix.build(10, 10) { |row, col| rand_cell_value(row, col) }
    end

    def rand_cell_value(row, col)
      grid_rand_picker.generate
    end

    def grid_rand_picker
      unless self.class.respond_to?(:grid_rand_picker)
        raise RandPickerNotFound, "#{self.class} must implement class method rand_picker"
      end
      self.class.grid_rand_picker
    end

    def grid
      if self.grid_marshaled
        @grid ||= Marshal.load(self.grid_marshaled)
      end
    end

    def grid=(grid)
      @grid = grid
      self.grid_marshaled = Marshal.dump(@grid)
    end

    RandPickerNotFound = Class.new(StandardError)
  end
end