require 'json'
require_relative 'download'

module S2Eco
  class StatsAnalyser

    def initialize(store, world)
      @store = store
      @world = world

      reset_logs(["context_model_count", "n_d_d_daily"])
    end

    def daily_analysis_on(day)
      # Ranking Distribution
        # ap ContextModel.group_and_count(:reputation).map {|res| {res[:reputation] => res[:count]} }

      # Normalized Degree Distribution
      # Device.eager_graph(:context_models).all do |d|
      normalized_degree_distribution = Array.new(11, 0)
      Device.eager(:context_models).all.each do |d|
        # p d.context_models.map(&:reputation).normalize!
        d.context_models.map(&:reputation).normalize!.each do |n|
          normalized_degree_distribution[n] += 1
        end
      end

      log([day] + normalized_degree_distribution, "n_d_d_daily")

      if day % 50 == 0
        dump_graph(day)
      end
    end   

    def final_analysis_on
      # Standard deviation of number of context models per device
      
      context_models_per_device_count = Hash.new(0)

      Device.eager(:context_models).all.each do |device|
        context_models_per_device_count[ device.id ] += device.context_models.count
      end

      ap context_models_per_device_count.values.standard_deviation
      context_models_per_device_count.values.each_with_index do |val, i|
        log([i, val], "context_model_count")
      end

    end

    def dump_graph(day)
      nodes = []
      edges = []
      Device.eager(:context_models).all.each do |d|
        nodes << { id: "d#{d.id}", size: d.context_models.count, color: "#F00" }
        d.context_models.each do |cm|
          nodes << { id: "n#{cm.id}", size: cm.reputation, color: "#0F0" }
          edges << { id: "c2d#{cm.id}", source: "n#{cm.id}", target: "d#{d.id}"}
        end
      end

      Service.eager(:context_models).all.each do |service|
        nodes << { id: "s#{service.id}", size: 1, color: "#00F"}
        service.context_models.each do |cm|
          edges << { id: "c2s#{cm.id}_#{service.id}", source: "n#{cm.id}", target: "s#{service.id}"}
        end
      end

      File.open("graph-visualization/data_#{day}.json", "w") do |f|
        f.puts JSON.pretty_generate({nodes: nodes, edges: edges})
      end
    end
  end
end