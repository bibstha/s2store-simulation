module S2Eco
  class S2Store

    def initialize
      @services = []
    end

    def add_service(service)
      @services << service
    end
  end
end