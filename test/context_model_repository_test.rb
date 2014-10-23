require_relative './test_helper'
require 'context_model_repository'

class ContextModelRepositoryTest < MiniTest::Test

  def test_create_initial_context_models
    cmr = ContextModelRepository.new
    cmr.create_initial_packages

    assert_equal 20, cmr.size
    assert_equal 10, cmr.select_by_feature_count(1).count
    assert_equal 10, cmr.select_by_feature_count(2).count
  end


end