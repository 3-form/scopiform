# frozen_string_literal: true

require 'active_support/concern'
require 'scopiform/scope_definition'

module Scopiform
  module Core
    extend ActiveSupport::Concern

    module ClassMethods
      def auto_scopes
        @auto_scopes || []
      end

      def auto_scopes_by_attribute(attribute)
        attribute = attribute.to_sym
        auto_scopes.select { |scope| scope.attribute == attribute }
      end

      def auto_scope?(name)
        auto_scopes.find { |scope| scope.name == name }
      end

      def auto_scope_add(attribute, block, prefix: nil, suffix: nil, **options)
        scope_name = "#{prefix}#{attribute}#{suffix}".underscore
        scope_name_sym = scope_name.to_sym
        scope scope_name_sym, block

        scope_definition = auto_scope_add_definition(attribute, prefix: prefix, suffix: suffix, **options)

        aliases_for(attribute).each do |alias_name|
          auto_scope_for_alias(alias_name, scope_definition)
        end
      end

      def alias_attribute(new_name, old_name)
        super(new_name, old_name)

        auto_scopes_by_attribute(old_name).each do |scope_definition|
          auto_scope_for_alias(new_name, scope_definition)
        end
      end

      private

      def auto_scope_add_definition(attribute, **options)
        definition = ScopeDefinition.new(attribute, **options)
        @auto_scopes ||= []
        @auto_scopes << definition

        definition
      end

      def auto_scope_for_alias(alias_name, scope_definition)
        scope_name = "#{scope_definition.prefix}#{scope_definition.attribute}#{scope_definition.suffix}".underscore
        alias_method_name = "#{scope_definition.prefix}#{alias_name}#{scope_definition.suffix}".underscore
        singleton_class.send(:alias_method, alias_method_name.to_sym, scope_name.to_sym)
        auto_scope_add_definition(alias_name, prefix: scope_definition.prefix, suffix: scope_definition.suffix, **scope_definition.options)
      end
    end
  end
end
