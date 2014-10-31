require_relative 'grid'

module S2Eco
  class Service < Grid

    attr_accessor :developer
    attr_accessor :reputation

    def self.rand_picker
      @rand_picker ||= begin
        p_values = [P_FEAT_S, 1 - P_FEAT_S]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize
      @reputation = 3
    end

    # def fill
      # @features = Matrix.build(10, 10) do |row, col|
      #   rand_cell_value(row, col).tap do |cell_filled|
      #     if !@is_malicious && cell_filled && row < 3 && col >= 7
      #       @is_malicious = cell_filled
      #     end
      #   end
      # end
    # end

    def is_malicious?
      @is_malicious || false
    end

    def top_services
    end

    def new_services
    end

    def keyword_search
    end

    def ==(service)
      @features = service.features
    end

    protected
    attr_reader :features
  end
end