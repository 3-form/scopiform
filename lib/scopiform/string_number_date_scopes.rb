# frozen_string_literal: true

require 'active_support/concern'

module Scopiform
  module StringNumberDateScopes
    extend ActiveSupport::Concern

    included do
      setup_string_number_and_date_auto_scopes
    end

    module ClassMethods
      private

      def setup_string_number_and_date_auto_scopes
        string_number_dates = Helpers::STRING_TYPES + Helpers::NUMBER_TYPES + Helpers::DATE_TYPES
        string_number_date_columns = safe_columns.select { |column| string_number_dates.include? column.type }
        string_number_date_columns.each do |column|
          name = column.name
          name_sym = name.to_sym
          type = column.type

          auto_scope_add(
            name,
            proc { |*value, ctx: nil, **| where(scopiform_arel(ctx)[name_sym].in(value.flatten)) },
            suffix: '_in',
            argument_type: [type]
          )

          auto_scope_add(
            name,
            proc { |*value, ctx: nil, **| where.not(scopiform_arel(ctx)[name_sym].in(value.flatten)) },
            suffix: '_not_in',
            argument_type: [type]
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **| where(scopiform_arel(ctx)[name_sym].lt(value)) },
            suffix: '_lt',
            argument_type: type
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **| where(scopiform_arel(ctx)[name_sym].lteq(value)) },
            suffix: '_lte',
            argument_type: type
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **| where(scopiform_arel(ctx)[name_sym].gt(value)) },
            suffix: '_gt',
            argument_type: type
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **| where(scopiform_arel(ctx)[name_sym].gteq(value)) },
            suffix: '_gte',
            argument_type: type
          )
        end
      end
    end
  end
end
