# frozen_string_literal: true

require 'active_support/concern'
require 'scopiform/utilities'

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
        string_number_columns = safe_columns.select do |column|
          string_numbers.include?(column.type) && !enum_attribute?(column.name)
        end
        string_number_columns.each do |column|
          name = column.name
          type = column.type
          cast = false

          # Numeric values don't work properly with `.matches`.  Using workaround
          # https://coderwall.com/p/qtgvdq/using-arel_table-for-ilike-yes-even-with-integers
          if Helpers::NUMBER_TYPES.include? type
            cast = true
            type = :string
          end

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **|
              arel_column = scopiform_arel(ctx)[name]
              arel_column = Utilities.cast_to_text(arel_column, connection) if cast
              where(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%"))
            },
            suffix: '_contains',
            argument_type: type,
            remove_for_enum: true
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **|
              arel_column = scopiform_arel(ctx)[name]
              arel_column = Utilities.cast_to_text(arel_column, connection) if cast
              where.not(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%"))
            },
            suffix: '_not_contains',
            argument_type: type,
            remove_for_enum: true
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **|
              arel_column = scopiform_arel(ctx)[name]
              arel_column = Utilities.cast_to_text(arel_column, connection) if cast
              where(arel_column.matches("#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%"))
            },
            suffix: '_starts_with',
            argument_type: type,
            remove_for_enum: true
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **|
              arel_column = scopiform_arel(ctx)[name]
              arel_column = Utilities.cast_to_text(arel_column, connection) if cast
              where.not(arel_column.matches("#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}%"))
            },
            suffix: '_not_starts_with',
            argument_type: type,
            remove_for_enum: true
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **|
              arel_column = scopiform_arel(ctx)[name]
              arel_column = Utilities.cast_to_text(arel_column, connection) if cast
              where(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}"))
            },
            suffix: '_ends_with',
            argument_type: type,
            remove_for_enum: true
          )

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **|
              arel_column = scopiform_arel(ctx)[name]
              arel_column = Utilities.cast_to_text(arel_column, connection) if cast
              where.not(arel_column.matches("%#{ActiveRecord::Base.sanitize_sql_like(value.to_s)}"))
            },
            suffix: '_not_ends_with',
            argument_type: type,
            remove_for_enum: true
          )
        end
      end
    end
  end
end
