require 'matrix'
require 'alias'

module S2Eco
  class Grid

    def fill
      @features = Matrix.build(10, 10) { rand_cell_value }
    end

    def rand_cell_value
      rand_picker.generate
    end

    def rand_picker
      unless self.class.respond_to?(:rand_picker)
        raise RandPickerNotFound, "#{self.class} must implement class method rand_picker"
      end
      self.class.rand_picker
    end

    def to_s
      @features and @features.row_vectors.map do |vector|
        vector.to_a.map { |x| x ? "1":"0" }.join(" ")
      end.join("\n")
    end

    RandPickerNotFound = Class.new(StandardError)
  end
end