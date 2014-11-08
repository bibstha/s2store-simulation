require_relative 'grid'

module S2Eco
  class Service < Sequel::Model
    
    many_to_one  :developer
    
    one_to_many  :downloads
    many_to_many :users, join_table: :downloads

    many_to_many :context_models


    include Grid

    attr_accessor :reputation
    attr_reader   :votes

    def self.grid_rand_picker
      @rand_picker ||= begin
        p_values = [P_FEAT_S, 1 - P_FEAT_S]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize(*args)
      super(*args)
      self.grid ||= generate_grid
    end

    def calculate_reputation
      @reputation = @votes.inject(:+).to_f / @votes.size unless @votes.empty?
    end

    def top_services
    end

    def new_services
    end

    def keyword_search
    end

  end
end