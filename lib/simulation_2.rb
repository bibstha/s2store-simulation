require_relative 'config'
require_relative 'grid'
require_relative 'context_model_repository'

# (1..DAYS_TOTAL).each do |day_t|
#   puts day_t
#
# end

class Simulation

  attr_accessor :simulation_days

  def cmr
    @cmr ||= ContextModelRepository.new.tap { |cmr| cmr.create_initial_packages }
  end

  def p_feat_cm
    P_FEAT_CM_MIN + (P_FEAT_CM_MAX.to_f - P_FEAT_CM_MIN) / DAYS_TOTAL * simulation_days
  end

  # Generate context model with p_feat_cm
  def create_cm
    Grid.new(p_feat_cm.to_i).tap { |cm| cm.generate_random_cells }
  end

  def actors
    1..2
  end

  def possible_related_cms_count(original_feature_count)
    max_possible_related_cms_count = NUM_CM_MIN + (NUM_CM_MAX - NUM_CM_MIN) / 100.0 * original_feature_count
    NUM_CM_MIN + (rand * max_possible_related_cms_count).to_i
  end

  def create_related_cms(cm)
    related_cms = []

    num_of_cms = possible_related_cms_count(cm.feature_count).to_i
    num_of_cms.times do

      feature_count = cmr.highest_feature_count
      grid = Grid.new(feature_count)
      grid.generate_random_cells

      related_cms << grid
    end

    related_cms
  end

  def simulate
    actors.each do |actor|
      # main cm for the service
      cm = create_cm

      related_cms = create_related_cms(cm)

      cmr << cm
      related_cms.each do |related_cm|
        cm.uses(related_cm)
        cmr << related_cm
      end

      # associate actor
      # associate cm to cm relationship

    end
  end



end
