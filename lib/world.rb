require_relative 'helper'
require_relative 'developer'

module S2Eco

  class World

    def initialize
      # starting population
        # make sure they are ready
      # starting entities
      # set starting date

      @current_day = 0
      @developers  = []
      increase_developer_population
    end

    def start
      1.upto(DAYS_TOTAL).each do |day|
        p "Day: #{day}"
        @current_day = day
        start_day
      end
    end

    def start_day
      entities = service_ready_developers.map do |dev|
        build_entities(dev)
      end
      update_s2store(entities)
      users_download_services
      users_provide_feedback
      calculate_system_rankings
      increase_agent_population
    end

    def service_ready_developers
      @developers.select { |dev| dev.service_ready?(@current_day) }
    end

    def build_entities(dev)
    end

    def update_s2store(entities)
    end

    def users_download_services
    end

    def users_provide_feedback
    end

    def calculate_system_rankings
    end

    def increase_agent_population
      increase_developer_population
    end

    #-- 
    def increase_developer_population
      devs_total_size     = pop_t_dev.ceil
      devs_yesterday_size = @developers.size
      devs_new_size       = devs_total_size - devs_yesterday_size

      1.upto(devs_new_size).each do 
        @developers << Developer.new(start_day: @current_day)
      end

      log(devs_new_size, 'dev_count')
    end

    def pop_t_dev
      POP_MIN_DEV + (POP_MAX_DEV - POP_MIN_DEV) / (1 + Math.exp(S_DEV * @current_day - D_DEV))
    end
  end
end

S2Eco::World.new.start