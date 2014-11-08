require 'matrix'

class Matrix
  public :"[]=", :set_element, :set_component
end

class Array
  def normalize!(ymin=1.0, ymax=10.0)
    return [10] if size == 1
    return [] if empty?
    xmin, xmax = self.minmax

    xrange = xmax - xmin
    yrange = ymax - ymin

    self.map! do |x| 
      if xrange == 0
        0
      else
        (ymin + (x - xmin) * (yrange / xrange)).round
      end
    end
  end
end