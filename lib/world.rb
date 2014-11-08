require_relative 'helper'
require_relative 'device'
require_relative 'developer'
require_relative 'service'
require_relative 'user'
require_relative 'stats_analyser'
require 'set'

module S2Eco

  class World

    attr_reader :current_day

    def initialize
      @current_day   = 0
      @inactive_devs = []

      @before_start_day_listener = []
      @after_start_day_listener = []
    end

    def add_before_start_day_listener(&blk)
      @before_start_day_listener << blk
    end

    def add_after_start_day_listener(&blk)
      @after_start_day_listener << blk
    end

    # total population on @current_day
    def pop_t_dev
      POP_MIN_DEV + (POP_MAX_DEV - POP_MIN_DEV) / (1 + Math.exp(S_DEV * @current_day - D_DEV))
    end

    # total devices population on @current_day
    def pop_t_devices
      POP_MIN_DEVICES + (POP_MAX_DEVICES - POP_MIN_DEVICES) / (1 + Math.exp(S_DEVICES * @current_day - D_DEVICES))
    end

    # probability of a service to have x devices on @current_day
    def p_t_device_per_service
      (P_SERVICE_DEVICE_MIN + P_M * @current_day).to_i
    end

    def start
      # 0th day
      increase_developer_population

      # 1 to DAYS_TOTAL
      1.upto(DAYS_TOTAL).each do |day|
        @before_start_day_listener.each{|l| l.call(day)}

        increase_day
        start_day
        
        @after_start_day_listener.each{|l| l.call(day)}
      end
    end

    def start_day
      S2STORE.current_day = @current_day
      increase_entities
      calculate_system_rankings
      increase_developer_population

    end

    def increase_entities
      increase_devices
      service_ready_developers = Developer.service_ready_developers(@current_day)
      increase_services(service_ready_developers)
    end

    def increase_devices
      device_count_yesterday = Device.count
      required_device_count  = pop_t_devices
      new_devices_count = required_device_count - device_count_yesterday
      new_devices = Array.new(new_devices_count) { Device.new(create_day: @current_day) }
      Device.multi_insert(new_devices)
    end

    def calculate_system_rankings
      S2STORE.calculate_system_rankings
    end

    def increase_developer_population
      # 1. Make some users inactive
      Developer.update_active_state

      # Increase population
      devs_total_size     = pop_t_dev.ceil
      devs_yesterday_size = Developer.count
      devs_new_size       = devs_total_size - devs_yesterday_size

      new_developers = Array.new(devs_new_size) { Developer.new(create_day: @current_day) }
      Developer.multi_insert(new_developers)
    end

    def increase_services(developers)
      # rework_existing_services(developers)
      services = developers.map do |dev|
        dev.produce_service(@current_day) do 
          total_devices_per_service = rand(1..p_t_device_per_service)
          S2STORE.create_service(create_day: @current_day, developer: dev, 
            device_count: total_devices_per_service)
          # ap "Total: #{p_t_device_per_service} : #{total_devices_per_service}"
        end
      end
      # Service.multi_insert(services)
    end

    # Make existing developers rework their applications
    def rework_existing_services(developers)
      # dev_groups = developers.all.group_by(&:dev_type)
    end

    def increase_day
      @current_day += 1
    end

  end
end

if __FILE__ == $0

  include S2Eco
  # reset_logs %w[dev_count service_count download_count_items download_count_fd votes_data periodic_service_ranking service_count_2]
  reset_logs %w[service_count_daily developer_count_daily user_count_daily vote_distribution_daily]
  
  world = World.new
  analyser = StatsAnalyser.new(S2STORE, world)

  world.add_before_start_day_listener do |day|
    ap "Start Day: #{day}"
    # ap "Start day #{day.to_s.ljust(4)}: Services: #{Service.count.to_s.ljust(5)}, "

    # ap "      Developers: #{Developer.count.to_s.ljust(5)} "\
    #   "(Inactive: #{Developer.inactive_developers.count.to_s.ljust(5)}, " \
    #   "Ready: #{Developer.service_ready_developers(day + 1).count.to_s.ljust(5)})"
    
    # ap "      Users - Total: #{User.count.to_s.ljust(5)}, ReadyToBrowse: #{User.ready_to_browse_on(day).count}, "
  end

  world.add_before_start_day_listener do |day|
    analyser.daily_analysis_on(day)
    # p "Total Services: #{Service.count}, Devs: #{Developer.count}"
    p "Total Services: #{Service.count}, Devices: #{Device.count}, CM: #{ContextModel.count}"
    # log([day, Service.count, Download.vote_count, Download.voted_service_count], "service_count_daily")
    # log([day, Developer.count, Developer.inactive_developers.count, Developer.service_ready_developers(day)], 
      # "developer_count_daily")
    # log([day, Device.count], "device_count")
    # log([day, User.count, User.voters.count], "user_count_daily")
    # log([day, Download.count], "vote_count_daily")
  end

  world.start 
  analyser.final_analysis_on
  
end