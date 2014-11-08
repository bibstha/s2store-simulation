require 'sequel'

module S2Eco
  class Device < Sequel::Model
    one_to_many :context_models
  end
end
