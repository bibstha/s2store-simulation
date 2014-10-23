require_relative 'grid'

class ContextModelRepository < Array
  def create_initial_packages
    [1, 2].each do |feature_count|
      10.times do
        grid = Grid.new(feature_count)
        push(grid)
      end
    end
  end

  def select_by_feature_count(count)
    select { |cm| cm.feature_count == count}
  end

  def related_cms
    @related_cms ||= []
  end

end