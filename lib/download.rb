require 'sequel'

module S2Eco
  class Download < Sequel::Model
    many_to_one :user
    many_to_one :service

    def self.vote_count
      exclude(:vote => nil).count
    end

    def self.voted_service_count
      exclude(:vote => nil).group(:service_id).count
    end
  end
end