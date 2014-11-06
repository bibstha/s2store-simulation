APP_ENV = 'dev' unless defined?(APP_ENV)

require 'sequel'
require 'logger'
require 'awesome_print'
require_relative 'constants'
require_relative 'log'
require_relative 'monkey_patches'
require_relative 'database_helper'

require_relative 'store'
S2STORE = S2Eco::Store.new

# DB.loggers << Logger.new($stdout)
