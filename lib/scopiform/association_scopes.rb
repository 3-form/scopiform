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

      private

      def setup_associations_auto_scopes
        reflect_on_all_associations.each do |association|
          setup_association_auto_scopes(association)
        end
      end

      def setup_association_auto_scopes(association)
        auto_scope_add(
          association.name,
          ->(value) { joins(association.name).merge(association.klass.apply_filters(value)) },
          suffix: '_is',
          argument_type: :hash
        )

        # Ordering
        auto_scope_add(
          association.name,
          ->(value) { joins(association.name).merge(association.klass.apply_orders(value)) },
          prefix: 'order_by_',
          argument_type: :hash,
          type: :order
        )
      end
    end
  end
end
