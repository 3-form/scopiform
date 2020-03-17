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
          arel_column = arel_table[name]

          auto_scope_add(
            name,
            proc { |value| where(name_sym => value) },
            suffix: '_in',
            argument_type: [type]
          )

          auto_scope_add(
            name,
            proc { |value| where.not(name_sym => value) },
            suffix: '_not_in',
            argument_type: [type]
          )

          auto_scope_add(
            name,
            proc { |value| where(arel_column.lt(value)) },
            suffix: '_lt',
            argument_type: type
          )

          auto_scope_add(
            name,
            proc { |value| where(arel_column.lteq(value)) },
            suffix: '_lte',
            argument_type: type
          )

          auto_scope_add(
            name,
            proc { |value| where(arel_column.gt(value)) },
            suffix: '_gt',
            argument_type: type
          )

          auto_scope_add(
            name,
            proc { |value| where(arel_column.gteq(value)) },
            suffix: '_gte',
            argument_type: type
          )
        end
      end
    end
  end
end
