require_relative 'helper'
require_relative 'developer'
require_relative 'service'
require_relative 'user'
require 'set'

module S2Eco

  class World

    attr_reader :current_day

    def initialize
      @current_day   = 0
      @developers    = []
      @users         = []
      @inactive_devs = []

      @active_user_day_cache = 0
      @active_users_today = []

      @before_start_day_listener = []
      @after_start_day_listener = []
    end

    def add_before_start_day_listener(&blk)
      @before_start_day_listener << blk
    end

    def add_after_start_day_listener(&blk)
      @after_start_day_listener << blk
    end

    def start
      increase_agent_population

      # 1.upto(5).each do |day|
      1.upto(DAYS_TOTAL).each do |day|
        @before_start_day_listener.each{|l| l.call(day)}

        increase_day
        start_day
        
        @after_start_day_listener.each{|l| l.call(day)}
      end
    end

    # always starts with the 1st day, no 0th day
    def start_day
      # malicious_service_count = S2STORE.malicious_service_count
      
      increase_entities
      users_download_services
      # users_provide_feedback
      # calculate_system_rankings
      increase_agent_population

    end

    def increase_entities
      service_ready_developers = Developer.service_ready_developers(@current_day)
      increase_services(service_ready_developers)
    end

    def users_download_services
      User.ready_to_browse_on(@current_day).each do |u|
        
        services = Set.new
        services.merge(S2STORE.top_new_services.all)
        services.merge(S2STORE.keyword_search_services.all)
        services.merge(S2STORE.top_best_services)

        u.select_interested_services(services).each do |interested_service|
          S2STORE.download(interested_service, u)
        end
      end
    end

    def users_provide_feedback
      User.ready_to_browse_on(@current_day).where(is_voter: true).each do |user|
        
        dls_to_vote = (user.unvoted_downloads.count * 0.1).ceil
        user.unvoted_downloads.order(Sequel.lit('RANDOM()')).limit(dls_to_vote).each do |dl|
          if dl.service.is_malicious?
            dl.update(vote: 1)
          elsif dl.service.is_buggy?
            dl.update(vote: rand(2..3))
          else
            dl.update(vote: rand(3..5))
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

    def pop_t_dev
      POP_MIN_DEV + (POP_MAX_DEV - POP_MIN_DEV) / (1 + Math.exp(S_DEV * @current_day - D_DEV))
    end

    def increase_user_population
      users_total_size     = pop_t_user.ceil
      users_yesterday_size = User.count
      users_new_required   = users_total_size - users_yesterday_size

      new_users = Array.new(users_new_required) { User.new(create_day: @current_day) }
      User.multi_insert(new_users)
    end

    def pop_t_user
      POP_MIN_USER + (POP_MAX_USER - POP_MIN_USER) / (1 + Math.exp(S_USER * @current_day - D_USER))
    end

    # We don't start with any entities
    def increase_entities_population
    end

    def increase_services(developers)
      services = developers.map do |dev|
        dev.produce_service(@current_day) do 
          Service.new(create_day: @current_day, developer: dev)
        end
      end
      Service.multi_insert(services)
    end

    def increase_day
      @current_day += 1
    end

  end
end

if __FILE__ == $0

  include S2Eco
  reset_logs %w[dev_count service_count download_count_items download_count_fd votes_data periodic_service_ranking]
  
  world = World.new
  analyser = StatsAnalyser.new(S2STORE, world)

  world.add_before_start_day_listener do |day|
    ap "Start day #{day.to_s.ljust(4)}: Services: #{Service.count.to_s.ljust(5)}, "

    ap "      Developers: #{Developer.count.to_s.ljust(5)} "\
      "(Inactive: #{Developer.inactive_developers.count.to_s.ljust(5)}, " \
      "Ready: #{Developer.service_ready_developers(day + 1).count.to_s.ljust(5)})"
    
    ap "      Users - Total: #{User.count.to_s.ljust(5)}, ReadyToBrowse: #{User.ready_to_browse_on(day).count}, "

  end

  world.add_after_start_day_listener do |day|
    
  end

  world.start 
  # analyser.analyse
  
end