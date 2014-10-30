require_relative 'grid'

module S2Eco
  class User < Grid

    def self.rand_picker
      @rand_picker ||= begin
        p_values = [P_PREF_USER, 1 - P_PREF_USER]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize(join_day)
      super()
      @join_day         = join_day
      @day              = join_day
      @last_browsed_day = join_day - rand(0..days_btw_browse)
    end

    def day=(day)
      @day = day
      if days_elapsed >= days_btw_browse
        @last_browsed_day = day
      end
    end

    def days_elapsed
      @day - @last_browsed_day
    end

    def days_btw_browse
      @days_btw_browse ||= rand(BRO_MIN..BRO_MAX)
    end

  end
end