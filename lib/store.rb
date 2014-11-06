require_relative 'download'

module S2Eco
  class Store

    attr_reader :services
    attr_accessor :current_day

    def initialize
      @services = []
      @cache    = {}
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
      unless @cache[:top_best_services_day] == current_day
        @cache[:top_best_services_day] = current_day
        weight_query = lambda do |value, day|
          Download.select(:service_id){(count(:service_id) * value).as("weight")}.where('create_day = ?', day).group(:service_id).to_a
        end
        
        all = []
        # D1
        all.push *weight_query.call(8, current_day - 1)
        all.push *weight_query.call(5, current_day - 2)
        all.push *weight_query.call(5, current_day - 3)
        all.push *weight_query.call(3, current_day - 4)

        service_weights = Hash.new(0)
        all.each do |download| 
          service_weights[ download[:service_id] ] += download[:weight]
        end

        service_ids = service_weights.to_a.sort_by(&:last).reverse[0..TOP_BEST_SERVICES].map(&:first)
        @top_best_services = Service.where(id: service_ids).all
      end
      @top_best_services
    end

    # Return count = rand(1..KEY_WRD_MAX)
    # Random rows from Service
    def keyword_search_services
      Service.order(Sequel.lit('RANDOM()')).limit(rand(1..KEY_WRD_MAX))
    end

    def download(service, user)
      Download.create(service: service, user: user, create_day: current_day)
    end
  end
end