require 'test_helper'

class AssociationTest < ActiveSupport::TestCase
  setup do
    @first_a = First.create(name: 'world')
    @first_b = First.create(name: 'hello')
    @first_c = First.create(name: 'middle')
    @second_a = Second.create(first: @first_a, name: 'abc', date: '2010-10-05', number: 5, boolean: true)
    @second_b = Second.create(first: @first_b, name: 'def', date: '2020-05-10', number: 10, boolean: false)
    @second_c = Second.create(first: @first_c, name: 'def', date: '2020-05-10', number: 10, boolean: false)
  end

  test 'check _is association' do
    results_a = Second.first_is(name_is: 'hello')

    assert_equal 1, results_a.size
    assert_equal @second_b, results_a.first
  end

  test 'check order_by_ association' do
    results_a = Second.order_by_first(name: :desc)

    assert_equal 3, results_a.size
    assert_equal @second_a, results_a.first
    assert_equal @second_c, results_a.second
    assert_equal @second_b, results_a.third
  end
end
