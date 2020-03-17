require 'test_helper'

class AssociationTest < ActiveSupport::TestCase
  setup do
    @first_a = First.create(name: 'world')
    @first_b = First.create(name: 'hello')
    @first_c = First.create(name: 'middle')
    @second_a = Second.create(first: @first_a, name: 'abc', date: '2010-10-05', number: 5, boolean: true)
    @second_b = Second.create(first: @first_b, name: 'def', date: '2020-05-10', number: 10, boolean: false)
    @second_c = Second.create(first: @first_c, name: 'def', date: '2020-05-10', number: 10, boolean: false)
    @fourth_a = Fourth.create(first: @first_a, name: 'poui')
    @fourth_b = Fourth.create(first: @first_b, name: 'lkjh')
    @fourth_c = Fourth.create(first: @first_c, name: 'mnb')
  end

  test 'check _is association' do
    results_a = Second.first_is(name_is: 'hello')

    assert_equal 1, results_a.size
    assert_equal @second_b, results_a.first
  end

  test 'complex or' do
    results_a = Second
                .apply_filters(or:
                  [
                    { first_is: { name_is: 'hello' } },
                    { first_is: { name_is: 'world' } }
                  ])

    assert_equal 2, results_a.size
  end

  test 'extra complex or' do
    result_a = \
      Second
      .apply_filters(or:
        [
          { first_is: { fourths_is: { name_is: 'poui' } } },
          { first_is: { fourths_is: { name_is: 'mnb' } } }
        ])

    assert_equal @second_a, result_a.first
    assert_equal @second_c, result_a.second
    assert_equal 2, result_a.size
  end

  test 'unbalanced complex or' do
    result_a = \
      Second
      .apply_filters(or:
        [
          { first_is: { fourths_is: { name_is: 'poui' } } },
          { first_is: { name_is: 'middle' } }
        ])

    assert_equal @second_a, result_a.first
    assert_equal @second_c, result_a.second
    assert_equal 2, result_a.size
  end

  test 'deeper or' do
    result_a = \
      Second
      .apply_filters(first_is:
        {
          or:
            [
              { fourths_is: { name_is: 'poui' } },
              { fourths_is: { name_is: 'mnb' } }
            ],
        })

    assert_equal @second_a, result_a.first
    assert_equal @second_c, result_a.second
    assert_equal 2, result_a.size
  end

  test 'check sort_by_ association' do
    results_a = Second.sort_by_first(name: :desc)

    assert_equal 3, results_a.size
    assert_equal @second_a, results_a.first
    assert_equal @second_c, results_a.second
    assert_equal @second_b, results_a.third
  end
end
