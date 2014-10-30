require 'alias'

module S2Eco
  class Developer
    attr_accessor :start_day
    attr_accessor :productive_days
    attr_accessor :dev_duration

    def self.active_state_picker
      @is_active_picker ||= begin
        p_values = [1-P_INACTIVE, P_INACTIVE]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize(start_day_initial = 0)
      @start_day = start_day_initial
      @is_active = true
      @productive_days = []
      @dev_duration = rand_dev_duration
    end

    def receive_new_service(day)
      days_taken = day - (productive_days.last || 0)
      if days_taken >= dev_duration
        productive_days << day
        true
      else
        false
      end
    end

    def is_active?
      @is_active
    end

    def refresh_active_state
      @is_active = self.class.active_state_picker.generate
    end

    private
    def rand_dev_duration
      @dev_duration_range ||= DEV_MIN..DEV_MAX
      rand(@dev_duration_range)
    end

  end
end