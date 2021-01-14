# frozen_string_literal: true

require 'active_support/concern'
require 'scopiform/utilities'

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
          proc { |value, ctx: nil|
            Utilities.association_scope(self, association, :apply_filters, value, ctx: ctx)
          },
          suffix: '_is',
          argument_type: :hash
        )

        # Sorting
        auto_scope_add(
          association.name,
          proc { |value, ctx: nil|
            Utilities.association_scope(self, association, :apply_sorts, value, ctx: ctx)
          },
          prefix: 'sort_by_',
          argument_type: :hash,
          type: :sort
        )
      end
    end
  end
end
