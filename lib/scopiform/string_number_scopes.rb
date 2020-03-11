# frozen_string_literal: true

require 'active_support/concern'

module Scopiform
  module StringNumberScopes
    extend ActiveSupport::Concern

    included do
      setup_string_and_number_auto_scopes
    end

    module ClassMethods
      private

      def setup_string_and_number_auto_scopes
        string_numbers = Helpers::STRING_TYPES + Helpers::NUMBER_TYPES
        string_number_columns = safe_columns.select { |column| string_numbers.include? column.type }
        string_number_columns.each do |column|
          name = column.name
          type = column.type
          arel_column = arel_table[name]

          # Numeric values don't work properly with `.matches`.  Using workaround
          # https://coderwall.com/p/qtgvdq/using-arel_table-for-ilike-yes-even-with-integers
          if Helpers::NUMBER_TYPES.include? column.type
            arel_column = Arel::Nodes::NamedFunction.new(
              'CAST',
              [arel_column.as('TEXT')]
            )

            type = :string
          end

          auto_scope_add(
            name,
            ->(value) { where(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%")) },
            suffix: '_contains',
            type: type
          )

          auto_scope_add(
            name,
            ->(value) { where.not(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%")) },
            suffix: '_not_contains',
            type: type
          )

          auto_scope_add(
            name,
            ->(value) { where(arel_column.matches("#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%")) },
            suffix: '_starts_with',
            type: type
          )

          auto_scope_add(
            name,
            ->(value) { where.not(arel_column.matches("#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%")) },
            suffix: '_not_starts_with',
            type: type
          )

          auto_scope_add(
            name,
            ->(value) { where(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}")) },
            suffix: '_ends_with',
            type: type
          )

          auto_scope_add(
            name,
            ->(value) { where.not(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}")) },
            suffix: '_not_ends_with',
            type: type
          )
        end
      end
    end
  end
end
