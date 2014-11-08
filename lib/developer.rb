require_relative 'helper'
require 'alias'

module S2Eco
  class Developer < Sequel::Model
    one_to_many :services

    attr_accessor :productive_days

    def self.active_state_picker
      @is_active_picker ||= begin
        p_values = [1-P_INACTIVE, P_INACTIVE]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize(*args)
      super(*args)
      self.create_day      ||= 0
      self.is_active       ||= true
      self.dev_duration    ||= DEV_DURATION_RANGE.sample
      # self.dev_type        ||= rand(3) # between 0 and 2 inclusive
      self.last_service_produced_day ||= self.create_day
    end

    # Support characteristic
    # 0 = fixes most of the bugs in each iteration
    # 1 = lazy and ignores any bugs
    # 2 = fixes and at the same time introduces malicious items
    def support_characteristic
      @support_characteristic ||= rand(0..2)
    end

    def produce_service(day, &blk)
      self.last_service_produced_day = day
      save
      return yield
    end

    def self.service_ready_developers(day)
      where(is_active: true).where('? - last_service_produced_day = dev_duration', day)
    end

    def self.inactive_developers
      where(is_active: false)
    end

    def self.update_active_state
      devs_that_will_become_inactive = []
      where(is_active: true).each do |dev|
        dev_stays_active = active_state_picker.generate
        devs_that_will_become_inactive << dev.id unless dev_stays_active
      end
      Developer.where(id: devs_that_will_become_inactive).update(is_active: false)
    end

  end

end
