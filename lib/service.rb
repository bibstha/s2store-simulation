require_relative 'grid'

module S2Eco
  class Service < Grid

    @instances = 0

    def self.get_new_id
      @instances += 1
    end

    attr_reader   :id
    attr_accessor :developer
    attr_accessor :reputation
    attr_accessor :download_count
    attr_reader   :votes

    def self.rand_picker
      @rand_picker ||= begin
        p_values = [P_FEAT_S, 1 - P_FEAT_S]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize
      @id             = self.class.get_new_id
      @reputation     = nil
      @download_count = 0
      @votes          = []
    end

    def calculate_reputation
      @reputation = @votes.inject(:+).to_f / @votes.size unless @votes.empty?
    end

    def is_malicious?
      @is_malicious ||= begin
        MALICIOUS_SIDE.each do |r|
          MALICIOUS_SIDE.each do |c|
            return true if @features[r, c]
          end
        end
        false
      end
    end

    def is_buggy?
      @is_buggy ||= begin
        BUGGY_SIDE.each do |r|
          BUGGY_SIDE.each do |c|
            return true if @features[r, c]
          end
        end
        false
      end   
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

  end
end