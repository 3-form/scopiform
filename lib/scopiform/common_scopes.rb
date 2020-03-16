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
            Proc.new { |value| where(name_sym => value) },
            suffix: '_is',
            argument_type: type
          )
          auto_scope_add(
            name,
            Proc.new { |value| where.not(name_sym => value) },
            suffix: '_not',
            argument_type: type
          )

          # Ordering
          auto_scope_add(
            name,
            ->(value = :asc) { order(name_sym => value) },
            prefix: 'order_by_',
            argument_type: :string,
            type: :order
          )
        end
      end
    end
  end
end
