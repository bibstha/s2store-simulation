require_relative 'constants'

module S2Eco
  class Developer
    attr_accessor :start_day
    attr_accessor :productive_days
    attr_accessor :dev_duration

    def initialize(start_day: 0)
      self.start_day = start_day
      @is_active = true
      @productive_days = []
      @dev_duration = rand_dev_duration
    end

    def service_ready?(day)
      (productive_days.first || 0) + dev_duration == day
    end

    def is_active?
      @is_active
    end

    private
    def rand_dev_duration
      rand(DEV_MIN..DEV_MAX)
    end

  end
end