require_relative 'download'

module S2Eco
  class StatsAnalyser

    def initialize(store, world)
      @store = store
      @world = world
    end

    def analyse
      # log_download_count_items
      # log_download_count_frequency_distribution
      # log_malicious_app_count
      log_service_total_votes
    end

    def periodic_analyse(day)
      log_periodic_service_ranking(day)
    end

    def log_download_count_items
      @store.services.group_by(&:download_count).map {|k, v| [k, v.map(&:id)]}
      .sort_by{ |k, v| k }.each do | download_count |
        log(download_count, "download_count_items")
      end
    end

    def log_download_count_frequency_distribution
      @store.services.group_by(&:download_count).map{|k,v| [k, v.size]}
      .sort.each do | download_count |
        log(download_count, "download_count_fd")
      end
    end

    def log_malicious_app_count
      log(@store.services.count(&:is_malicious?), "malicious_count")
      log(@store.services.count(&:is_buggy?), "buggy_count")
    end

    def log_service_total_votes
      voted_services = @world.users.collect{ |u| u.voted_services.to_a }.flatten(1)
      
      voted_services_grouped = voted_services.group_by(&:first).map{|k,v| [k, v.map{|s,vote| vote}]}.sort_by{|k,v| v.size}
      .to_h
      
      p voted_services_grouped.first
      voted_services_grouped.each_with_index do |(service, votes), index|
        log([index, votes.size, votes.inject(:+).to_f / votes.size], "votes_data")
      end
      # p @world.users.first.voted_services
      # .flatten(1).group_by(&:first)
      # .tap do |service_detail|
      #   p service_detail.first.id
      #   p service_detail[1].size
      # end
    end

    #periodic functions
    def log_periodic_service_ranking(day)
      @store.services.select(&:reputation).group_by(&:reputation)
      .map{|rep, services| [rep, services.size]}.each do |data|
        log([day, data].flatten, "periodic_service_ranking")
      end
    end

    def daily_analysis_on(day)

      # Vote Distribution
      average_votes = Download.select(:service_id){round(avg(vote)).as(vote)}
      .exclude(:vote => nil).group(:service_id).all
      vote_count = average_votes.group_by{ |dl| dl[:vote] }.map{|k,v| [k.to_i, v.count]}.to_h
      
      vote_sorted = [1,2,3,4,5].map { |k| vote_count[k] || 0 }
      log([day] + vote_sorted, "vote_distribution_daily")
    end   
  end
end