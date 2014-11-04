require_relative 'helper'
require_relative 'developer'
require_relative 'service'
require_relative 'user'
require 'set'

module S2Eco

  class World

    attr_reader :users
    attr_reader :developers
    attr_reader :current_day

    def initialize
      @current_day   = 0
      @developers    = []
      @users         = []
      @inactive_devs = []

      @active_user_day_cache = 0
      @active_users_today = []
    end

    def start
      increase_agent_population
      increase_entities_population

      1.upto(DAYS_TOTAL).each do |day|
        increase_day
        start_day

        if block_given?
          yield(day)
        end

      end
    end

    # always starts with the 1st day, no 0th day
    def start_day
      service_ready_developers = @developers.select { |dev| dev.receive_new_service(@current_day) }

      malicious_service_count = S2STORE.malicious_service_count
      
      log(
        [
          @current_day, 
          S2STORE.service_count, 
          # service_ready_developers.size, 
          malicious_service_count,
          @developers.size
        ], 
        'service_count'
      )
      
      entities_build_today = service_ready_developers.map do |dev|
        build_entities(dev).tap do
          dev.refresh_active_state
        end
      end

      update_s2store(entities_build_today)
      users_download_services
      users_provide_feedback
      calculate_system_rankings
      increase_agent_population

    end

    def build_entities(dev)
      service = [
        build_service(dev),
        # context models,
        # access groups
      ]
    end

    # depends upon the return values of build_entities
    def update_s2store(entities_ary)
      entities_ary.each do |entities|
        service = entities.first
        S2STORE.upload_service(service)
      end
    end

    def active_users_today
      if @active_user_day_cache == @current_day
        @active_users_today
      else
        @active_user_day_cache = @current_day
        @active_users_today = users.select do |u|
          u.day = @current_day
          u.days_elapsed == 0
        end
      end
    end

    def users_download_services
      puts "\t Active Users: #{active_users_today.size}"
      active_users_today.each do |u|
        # latest services

        services = Set.new
        services.merge(S2STORE.top_new_services)
        services.merge(S2STORE.keyword_search_services)
        services.merge(S2STORE.top_best_services)

        u.select_interested_services(services).each do |interested_service|
          S2STORE.download(interested_service, u)
        end
      end
    end

    def users_provide_feedback
      active_users_today.select(&:is_voter?).each do |voter|
        unvoted_services = voter.installed_services - voter.voted_services
        unvoted_services.to_a.sample(unvoted_services.size * 0.1).each do |service|
          if service.is_malicious?
            S2STORE.vote(service, voter, 1)
          elsif service.is_buggy?
            S2STORE.vote(service, voter, rand(2..3))
          else
            S2STORE.vote(service, voter, rand(3..5))
          end
        end
      end
    end

    def calculate_system_rankings
      S2STORE.services.each(&:calculate_reputation)
    end

    def increase_agent_population
      increase_developer_population
      increase_user_population
    end

    #-- 
    def increase_developer_population
      @developers.select { |dev| !dev.is_active? }.tap { |arr| @inactive_devs.push(*arr) }
      @developers.delete_if { |dev| !dev.is_active? }

      devs_total_size     = pop_t_dev.ceil
      devs_yesterday_size = @developers.size + @inactive_devs.size
      devs_new_size       = devs_total_size - devs_yesterday_size

      1.upto(devs_new_size).each do 
        @developers << Developer.new(@current_day)
      end
    end

    def pop_t_dev
      POP_MIN_DEV + (POP_MAX_DEV - POP_MIN_DEV) / (1 + Math.exp(S_DEV * @current_day - D_DEV))
    end

    def increase_user_population

      users_total_size     = pop_t_user.ceil
      users_yesterday_size = @users.size
      users_new_required   = users_total_size - users_yesterday_size

      1.upto(users_new_required).each do
        user = User.new(@current_day)
        user.fill
        @users << user
      end
    end

    def pop_t_user
      POP_MIN_USER + (POP_MAX_USER - POP_MIN_USER) / (1 + Math.exp(S_USER * @current_day - D_USER))
    end

    def increase_entities_population
    end

    def build_service(dev)
      service = Service.new
      service.fill
      service.developer = dev
      service
    end

    def increase_day
      @current_day += 1
    end

  end
end

if __FILE__ == $0
  reset_logs %w[dev_count service_count download_count_items download_count_fd votes_data periodic_service_ranking]
  
  world = S2Eco::World.new
  analyser = S2Eco::StatsAnalyser.new(S2STORE, world)

  world.start do |day|
    puts "DAY: #{day} Services: #{S2STORE.services.size}"
    if day % 20 == 0
      analyser.periodic_analyse(day)
    end
  end

  analyser.analyse
  
end