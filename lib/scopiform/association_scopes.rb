# frozen_string_literal: true

require 'active_support/concern'

module Scopiform
  module AssociationScopes
    extend ActiveSupport::Concern

    included do
      setup_associations_auto_scopes
    end

    module ClassMethods
      def reflection_added(_name, reflection)
        setup_association_auto_scopes(reflection)
      end

      def scopiform_joins(*args, **kargs)
        respond_to?(:left_outer_joins) ? left_outer_joins(*args, **kargs) : eager_load(*args, **kargs)
      end

      private

      def setup_associations_auto_scopes
        reflect_on_all_associations.each do |association|
          setup_association_auto_scopes(association)
        end
      end

      def setup_association_auto_scopes(association)
        auto_scope_add(
          association.name,
          Proc.new { |value, joins: nil|
            is_root = joins.nil?
            joins = {} if is_root

            joins[association.name] ||= {}
            applied = association.klass.apply_filters(value, joins: joins[association.name])

            if is_root
              scopiform_joins(joins).merge(applied)
            else
              all.merge(applied)
            end
          },
          suffix: '_is',
          argument_type: :hash
        )

        # Ordering
        auto_scope_add(
          association.name,
          Proc.new { |value| scopiform_joins(association.name).merge(association.klass.apply_orders(value)) },
          prefix: 'order_by_',
          argument_type: :hash,
          type: :order
        )
      end
    end
  end
end
