require_relative 'grid'

module S2Eco
  class Service < Sequel::Model
    
    many_to_one  :developer
    one_to_many  :downloads
    many_to_many :users, join_table: :downloads

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
      self.grid = generate_grid
    #   @id             = self.class.get_new_id
    #   @reputation     = nil
    #   @download_count = 0
    #   @votes          = []
    #   @create_day     = create_day
    end

    def download_count
      users.count
    end

    def calculate_reputation
      @reputation = @votes.inject(:+).to_f / @votes.size unless @votes.empty?
    end

    def is_malicious?
      @is_malicious ||= begin
        MALICIOUS_SIDE.each do |r|
          MALICIOUS_SIDE.each do |c|
            return true if grid[r, c]
          end
        end
        false
      end
    end

    def is_buggy?
      @is_buggy ||= begin
        BUGGY_SIDE.each do |r|
          BUGGY_SIDE.each do |c|
            return true if grid[r, c]
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

  end
end