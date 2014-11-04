module S2Eco
  class Store

    attr_reader :services

    def initialize
      @services = []
    end

    def upload_service(service)
      @services << service
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
      []
    end

    def top_best_services
      []
    end

    # Return random number of services returned
    def keyword_search_services
      total_services = @services.count
      search_results_count = rand(1..KEY_WRD_MAX)
      search_results_keys  = Array.new(search_results_count) { rand(0..(total_services-1)) }
      
      search_results_keys.map do |key|
        @services[key]
      end
      
    end

    def download(service, user)
      service.download_count += 1
      user.install_service(service)
    end

    def vote(service, user, amount)
      user.voted_services[service] = amount
      service.votes << amount
    end
  end
end