require_relative 'helper'
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

      S2STORE.current_day = @current_day
      increase_entities
      users_download_services
      users_provide_feedback
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

        dls_to_vote = (user.unvoted_downloads.count * P_APPS_TO_VOTE).ceil
        # ap "Unvoted Downloads #{dls_to_vote}"
        if dls_to_vote > 0
          user.unvoted_downloads.order(Sequel.lit('RANDOM()')).limit(dls_to_vote).each do |dl|
            # if dl.service.is_malicious?
              # dl.update(vote: 1)
            # elsif dl.service.is_buggy?
            if dl.service.is_buggy?
              keep_installed = [true, false].sample
              if keep_installed
                dl.update(vote: rand(1..2))
              else
                dl.delete
              end
            else
              dl.update(vote: rand(3..5))
            end
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
      rework_existing_services(developers)
      services = developers.map do |dev|
        dev.produce_service(@current_day) do
          Service.new(create_day: @current_day, developer: dev)
        end
      end
      Service.multi_insert(services)
    end

    # Make existing developers rework their applications
    def rework_existing_services(developers)
      dev_groups = developers.all.group_by(&:dev_type)
      # ap dev_groups
      # dev_group_str = "Imporvers: "
      # dev_groups.each do |type, devs|
      #   dev_group_str << "#{type}: #{dev_groups[type].count}, " if dev_groups[type]
      # end
      # ap dev_group_str
      # ap "Improvers: #{dev_groups[0].count}, Ignorers: #{dev_groups[1].count}, Improvers: #{dev_groups[2].count}"

      # 0: Improvers
      dev_groups[0] and dev_groups[0].each do |developer|
        developer.services.each do |service|
          service.fix_bug!
        end
      end
      # 1: Ignorers
      # do nothing
      # 2: Malicious
      dev_groups[2] and dev_groups[2].each do |developer|
        developer.services.each do |service|
          service.introduce_bug!
        end
      end
    end

    def increase_day
      @current_day += 1
    end

  end
end

if __FILE__ == $0

  include S2Eco
  RubyProf.start

  # reset_logs %w[dev_count service_count download_count_items download_count_fd votes_data periodic_service_ranking service_count_2]
  reset_logs %w[service_count_daily developer_count_daily user_count_daily vote_distribution_daily]

  world = World.new
  analyser = StatsAnalyser.new(S2STORE, world)

  world.add_before_start_day_listener do |day|
    ap "Start Day: #{day}"
    # ap "Start day #{day.to_s.ljust(4)}: Services: #{Service.count.to_s.ljust(5)}, "
    #
    # ap "      Developers: #{Developer.count.to_s.ljust(5)} "
    # #   "(Inactive: #{Developer.inactive_developers.count.to_s.ljust(5)}, " \
    # #   "Ready: #{Developer.service_ready_developers(day + 1).count.to_s.ljust(5)})"
    #
    # ap "      Users - Total: #{User.count.to_s.ljust(5)}, ReadyToBrowse: #{User.ready_to_browse_on(day).count}, "
  end

  world.add_before_start_day_listener do |day|
    analyser.daily_analysis_on(day)
    # log([day, Service.count, Download.vote_count, Download.voted_service_count], "service_count_daily")
    # log([day, Developer.count, Developer.inactive_developers.count, Developer.service_ready_developers(day)],
      # "developer_count_daily")
    # log([day, User.count, User.voters.count], "user_count_daily")
    # log([day, Download.count], "vote_count_daily")
  end

  world.start
  # analyser.analyse

  result  = RubyProf.stop
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT)

end
