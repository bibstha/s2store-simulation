module S2Eco
  class Download < Sequel::Model
    many_to_one :user
    many_to_one :service
  end
end