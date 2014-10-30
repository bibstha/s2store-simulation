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

    def fill
      @features = Matrix.build(10, 10) do |row, col|
        rand_cell_value.tap do |cell_filled|
          if !@is_malicious && cell_filled && row < 3 && col >= 7
            @is_malicious = cell_filled
          end
        end
      end
    end

    def is_malicious?
      @is_malicious || false
    end
  end
end