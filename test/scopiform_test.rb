require 'test_helper'

class Scopiform::Test < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, Scopiform
  end

  test 'basic auto scope' do
    assert_respond_to First, :name_is
  end

  test 'auto scope definition' do
    assert_not_empty First.auto_scopes
  end

  test 'aliases get auto scopes' do
    assert_respond_to First, :name_alias_is
  end
end
