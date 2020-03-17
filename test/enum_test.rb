require 'test_helper'

class EnumTest < ActiveSupport::TestCase
  setup do
    @first_a = First.create(name: 'world')
    @first_b = First.create(name: 'hello')
    @first_c = First.create(name: 'middle')
    @fourth_a = Fourth.create(first: @first_a, name: 'poui', status: :discontinued)
    @fourth_b = Fourth.create(first: @first_b, name: 'lkjh', status: :active)
    @fourth_c = Fourth.create(first: @first_c, name: 'mnb', status: :inactive)
  end

  test 'basic enum works' do
    results = Fourth.status_is('inactive')
    assert_equal 1, results.size
    assert_equal @fourth_c, results.first
  end

  test 'enums do not include contains-like scopes' do
    assert_not_respond_to First, :status_contains
    assert_not_respond_to First, :status_not_contains
    assert_not_respond_to First, :status_starts_with
    assert_not_respond_to First, :status_ends_with
  end
end
