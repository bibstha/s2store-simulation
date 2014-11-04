require_relative 'grid'
require 'set'

module S2Eco
  class User < Sequel::Model
    
    # many_to_many :services
    one_to_many :downloads
    many_to_many :services, join_table: :downloads

    include Grid

    attr_reader :installed_services
    attr_reader :voted_services

    def self.rand_picker
      @rand_picker ||= begin
        p_values = [P_PREF_USER, 1 - P_PREF_USER]
        AliasTable.new([true, false], p_values)
      end
    end

    def self.vote_rand_picker
      @vote_rand_picker ||= begin
        p_values = [P_VOTER, 1 - P_VOTER]
        AliasTable.new([true, false], p_values)
      end
    end

    def initialize(*args)
      super(*args)
      self.create_day       ||= 0
      self.days_btw_browse  ||= rand(BROWSE_RANGE)
      self.last_browse_day  ||= create_day - rand(0..days_btw_browse)
      self.grid             ||= generate_grid
      self.is_voter         ||= self.class.vote_rand_picker.generate
    end
    # def initialize(join_day)
    #   super()
    #   @join_day           = join_day
    #   @day                = join_day
    #   @last_browsed_day   = join_day - rand(0..days_btw_browse)
    #   @installed_services = Set.new
    #   @voted_services     = {}

    #   # Min app rating for download
    #   @voter = self.class.vote_rand_picker.generate # true or false
    # end

    def day=(day)
      @day = day
      if days_elapsed >= days_btw_browse
        @last_browsed_day = day
      end
    end

    def select_interested_services(services)
      services -= self.services
      services.select do |service|
        accepted = true
        catch(:false) do
          0.upto(service.grid.row_count-1).each do |r|
            0.upto(service.grid.column_count-1).each do |c|
              if service.grid[r, c] && !grid[r, c]
                accepted = false
                throw :false
              end
            end
          end
        end
        accepted
      end
    end

    def unvoted_downloads
      Download.where(user_id: id, vote: nil)
    end

    def rand_cell_value(row, col)
      if row < U_AVOID_SIZE && col < U_AVOID_SIZE
        false
      else
        super
      end
    end

    # def install_service(service)
    #   @installed_services << service
    # end

    # def service_installed?(service)
    #   @installed_services.include?(service)
    # end

    def is_voter?
      @voter
    end

    def self.ready_to_browse_on(day)
      where('? - last_browse_day = days_btw_browse', day)
    end
  end
end