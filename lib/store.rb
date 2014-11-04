module S2Eco
  class Store

    attr_reader :services
    attr_reader :current_day

    def initialize
      @services = []
    end

    def day=(day)
      @current_day = day
    end

    def service_count
      @services.count
    end

    def malicious_service_count
      @services.count { |s| s.is_malicious? }
    end

    def group_duplicate_services
      @services.group_by { |s| s }
    end

    def top_new_services
      Service.reverse_order(:create_day).limit(TOP_NEW_SERVICES)
    end

    def top_best_services
      []
    end

    # Return count = rand(1..KEY_WRD_MAX)
    # Random rows from Service
    def keyword_search_services
      Service.order(Sequel.lit('RANDOM()')).limit(rand(1..KEY_WRD_MAX))
    end

    def download(service, user)
      user.add_service(service)
      user.save
    end

    def vote(service, user, amount)
      user.voted_services[service] = amount
      service.votes << amount
    end
  end
end