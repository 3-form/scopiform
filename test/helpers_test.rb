require 'test_helper'

class HelpersTest < ActiveSupport::TestCase
  test 'helper methods exist' do
    assert_respond_to First, :attribute_aliases_inverted
    assert_respond_to First, :resolve_alias
    assert_respond_to First, :aliases_for
    assert_respond_to First, :column
    assert_respond_to First, :association
  end

  test 'bad column name is nil' do
    assert_nil First.column(:does_not_exist)
  end

  test 'id returns primary key' do
    assert_equal 'rowid', Third.resolve_alias(:id)
  end

  test 'has constants' do
    assert_equal %i[string text], Scopiform::Helpers::STRING_TYPES
  end

  test 'does not throw when table table does not exist' do
    NoTable
  end
end
