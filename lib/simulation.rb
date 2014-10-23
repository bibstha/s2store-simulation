require_relative 'config'
require_relative 'grid'

# (1..DAYS_TOTAL).each do |day_t|
#   puts day_t
#
# end

class Simulation

  attr_accessor :simulation_days

  def cmr
    @cmr ||= ContextModelRepository.new
    @cmr.create_initial_packages
    @cmr
  end

  def p_feat_cm
    P_FEAT_CM_MIN + (P_FEAT_CM_MAX.to_f - P_FEAT_CM_MIN) / DAYS_TOTAL * simulation_days
  end

  # Generate context model with p_feat_cm
  def create_cm
    cm = Grid.new(p_feat_cm.to_i)
    cm.generate_random_cells
    cm
  end

  def actors
    [1..10]
  end

  def create_related_cms(cm)

  end

  def simulate
    actors.each do
      # main cm for the service
      cm = create_cm

      related_cms = create_related_cms(cm)
      cmr.add(cm)
      cmr.add(related_cms)

      # associate actor
      # associate cm to cm relationship
    end
  end



end
