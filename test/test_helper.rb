APP_ENV = 'test'
require 'minitest/pride'
require 'minitest/autorun'
$:.unshift File.expand_path("lib")
require 'helper'

class MiniTest::Test
  alias_method :_original_run, :run

  def run(*args, &block)
    result = nil
    Sequel::Model.db.transaction(:rollback => :always, :auto_savepoint=>true) do
      result = _original_run(*args, &block)
    end
    result
  end
end

DB.loggers << Logger.new($stdout)