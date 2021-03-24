# frozen_string_literal: true

require 'active_support/concern'

module Scopiform
  module CommonScopes
    extend ActiveSupport::Concern

    included do
      setup_common_auto_scopes
    end

    module ClassMethods
      private

      def setup_common_auto_scopes
        safe_columns.each do |column|
          name = column.name
          name_sym = name.to_sym
          type = column.type

          auto_scope_add(
            name,
            proc { |value, ctx: nil, **| where(scopiform_arel(ctx)[name_sym].eq(value)) },
            suffix: '_is',
            argument_type: type
          )
          auto_scope_add(
            name,
            proc { |value, ctx: nil, **| where.not(scopiform_arel(ctx)[name_sym].eq(value)) },
            suffix: '_not',
            argument_type: type
          )

          # Sorting
          auto_scope_add(
            name,
            proc { |value = :asc, ctx: nil, **| order(scopiform_arel(ctx)[name_sym].send(value.to_s.downcase)) },
            prefix: 'sort_by_',
            argument_type: :string,
            type: :sort
          )

          # Grouping
          auto_scope_add(
            name,
            proc { |value = true, ctx: nil, **| group(scopiform_arel(ctx)[name_sym]) if value },
            prefix: 'group_by_',
            argument_type: :boolean,
            type: :group
          )
        end
      end
    end
  end
end
