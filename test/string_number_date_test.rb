require 'test_helper'

class StringNumberDateTest < ActiveSupport::TestCase
  setup do
    @first = First.create(name: 'first')
    @second_a = Second.create(first: @first, name: 'abc', date: '2010-10-05', number: 5, boolean: true)
    @second_b = Second.create(first: @first, name: 'def', date: '2020-05-10', number: 10, boolean: false)
  end

  test 'available on only string number and date column types' do
    assert_respond_to Second, :id_in
    assert_respond_to Second, :name_in
    assert_respond_to Second, :number_in
    assert_respond_to Second, :date_in

    assert_not_respond_to Second, :boolean_in
  end

  test 'check _in string' do
    results_a = Second.name_in(%w[abc def ghi])
    results_b = Second.name_in(%w[def])

    assert_equal 2, results_a.size
    assert_equal @second_a, results_a.first
    assert_equal @second_b, results_a.second

    assert_equal 1, results_b.size
    assert_equal @second_b, results_b.first
  end

  test 'check _in number' do
    results_a = Second.number_in([5, 10, 15])
    results_b = Second.number_in([10])

    assert_equal 2, results_a.size
    assert_equal @second_a, results_a.first
    assert_equal @second_b, results_a.second

    assert_equal 1, results_b.size
    assert_equal @second_b, results_b.first
  end

  test 'check _in date' do
    results_a = Second.date_in(['2010-10-05', Date.iso8601('2020-05-10'), Date.iso8601('2030-07-12')])
    results_b = Second.date_in(['2020-05-10'])

    assert_equal 2, results_a.size
    assert_equal @second_a, results_a.first
    assert_equal @second_b, results_a.second

    assert_equal 1, results_b.size
    assert_equal @second_b, results_b.first
  end

  test 'check _not_in string' do
    results_a = Second.name_not_in(%w[abc def ghi])
    results_b = Second.name_not_in(%w[def])

    assert_equal 0, results_a.size

    assert_equal 1, results_b.size
    assert_equal @second_a, results_b.first
  end

  test 'check _not_in number' do
    results_a = Second.number_not_in([5, 10, 15])
    results_b = Second.number_not_in([10])

    assert_equal 0, results_a.size

    assert_equal 1, results_b.size
    assert_equal @second_a, results_b.first
  end

  test 'check _not_in date' do
    results_a = Second.date_not_in(['2010-10-05', Date.iso8601('2020-05-10'), Date.iso8601('2030-07-12')])
    results_b = Second.date_not_in(['2020-05-10'])

    assert_equal 0, results_a.size

    assert_equal 1, results_b.size
    assert_equal @second_a, results_b.first
  end
end
