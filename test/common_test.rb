require 'test_helper'

class CommonTest < ActiveSupport::TestCase
  setup do
    @first_a = First.create(name: 'abc')
    @first_b = First.create(name: 'def')
  end

  test 'available on all column types' do
    assert_respond_to Second, :id_is
    assert_respond_to Second, :name_is
    assert_respond_to Second, :date_is
    assert_respond_to Second, :number_is
    assert_respond_to Second, :boolean_is
  end

  test 'check _is' do
    results = First.name_is('abc')
    assert_equal 1, results.size
    assert_equal @first_a, results.first
  end

  test 'check _not' do
    results = First.name_not('abc')
    assert_equal 1, results.size
    assert_equal @first_b, results.first
  end

  test 'check order_by_ ascending' do
    results = First.order_by_name(:asc)
    assert_equal 2, results.size
    assert_equal @first_a, results.first
    assert_equal @first_b, results.second
  end

  test 'check order_by_ descending' do
    results = First.order_by_name(:desc)
    assert_equal 2, results.size
    assert_equal @first_b, results.first
    assert_equal @first_a, results.second
  end

  test 'check order_by_ without arg is same as ascending' do
    results_a = First.order_by_name
    results_b = First.order_by_name(:asc)

    assert_equal results_a, results_b
  end
end
