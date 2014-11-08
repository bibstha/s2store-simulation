require 'sequel'
module S2Eco
  class ContextModel < Sequel::Model
    many_to_one :device
    many_to_one :developer

    many_to_many :services
  end
end