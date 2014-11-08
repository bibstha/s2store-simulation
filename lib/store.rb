require_relative 'download'
require_relative 'context_model'

module S2Eco
  class Store

    attr_reader :services
    attr_accessor :current_day

    def initialize
      @services = []
      @cache    = {}
    end

    def create_service(opt)
      create_day = opt.fetch(:create_day)
      developer  = opt.fetch(:developer)
      device_count = opt.fetch(:device_count)
      
      service = Service.create(create_day: create_day, developer: developer, device_count: device_count)

      device_ids = (1..Device.count).to_a.sample(device_count)
      device_ids.each do |device_id|
        cm = developer_chooses_context_model(device_id)
        cm.reputation += 1
        cm.save
        service.add_context_model(cm)
      end

      service
    end

    # Where the MAGIC happens
    def developer_chooses_context_model(device_id)
      # use_existing_context_model = [true, true, true, true, true, true, false].sample
      use_existing_context_model = [ [true] * 10, false ].flatten.sample
      cm = if use_existing_context_model
        get_context_models_for(device_id)
      end
      cm = ContextModel.create(device_id: device_id) unless cm
      cm
    end

    def get_context_models_for(device_id)
      cms = ContextModel.where(device_id: device_id).reverse_order(:reputation).limit(10)
      cms_array = []
      cms.each do |context_model|
        context_model.reputation.times { cms_array << context_model }
      end
      cms_array.sample
    end

    def calculate_system_rankings
      # do nothing, reputations are already added by create_service
    end
  end
end