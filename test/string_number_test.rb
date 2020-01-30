require 'test_helper'

class StringNumberTest < ActiveSupport::TestCase
  setup do
    @first_a = First.create(name: 'abc')
    @first_b = First.create(name: 'def')
  end

  test 'available on only string and number column types' do
    assert_respond_to Second, :id_contains
    assert_respond_to Second, :name_contains
    assert_respond_to Second, :number_contains

    refute_respond_to Second, :date_contains
    refute_respond_to Second, :boolean_contains
  end

  test 'check _contains' do
    results = First.name_contains('b')
    assert_equal 1, results.size
    assert_equal @first_a, results.first
  end

  test 'check _not_contains' do
    results = First.name_not_contains('b')
    assert_equal 1, results.size
    assert_equal @first_b, results.first
  end

  test 'check _starts_with' do
    results_a = First.name_starts_with('ab')
    results_b = First.name_starts_with('e')

    assert_equal 1, results_a.size
    assert_equal @first_a, results_a.first

    assert_empty results_b
  end

  test 'check _not_starts_with' do
    results_a = First.name_not_starts_with('ab')
    results_b = First.name_not_starts_with('e')

    assert_equal 1, results_a.size
    assert_equal @first_b, results_a.first

    assert_equal 2, results_b.size
  end

  test 'check _ends_with' do
    results_a = First.name_ends_with('bc')
    results_b = First.name_ends_with('e')

    assert_equal 1, results_a.size
    assert_equal @first_a, results_a.first

    assert_empty results_b
  end

  test 'check _not_ends_with' do
    results_a = First.name_not_ends_with('bc')
    results_b = First.name_not_ends_with('e')

    assert_equal 1, results_a.size
    assert_equal @first_b, results_a.first

    assert_equal 2, results_b.size
  end
end
