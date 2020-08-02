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
        auto_scopes.find { |scope| scope.name == name }.present?
      end

      def auto_scope_add(attribute, block, prefix: nil, suffix: nil, **options)
        scope_definition = auto_scope_add_definition(attribute, prefix: prefix, suffix: suffix, **options)

        scope scope_definition.name, block

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

      def enum(definitions)
        super(definitions)

        definitions.each_key { |name| update_scope_to_enum(name) }
      end

      private

      def update_scope_to_enum(name)
        scopes = auto_scopes_by_attribute(name)

        scopes.each do |scope|
          if scope.options[:type].blank?
            argument_type = scope.options[:argument_type]
            scope.options[:argument_type] = argument_type.is_a?(Array) ? [:string] : :string if argument_type
            scope.options[:type] = :enum
          end

          if scope.options[:remove_for_enum]
            singleton_class.send(:remove_method, scope.name)
            @auto_scopes.delete(scope)
          end
        end
      end

      def auto_scope_add_definition(attribute, **options)
        definition = ScopeDefinition.new(attribute, **options)
        @auto_scopes ||= []
        @auto_scopes << definition

        definition
      end

      def auto_scope_for_alias(alias_name, scope_definition)
        alias_scope_definition = scope_definition.dup
        alias_scope_definition.attribute = alias_name.to_sym

        @auto_scopes ||= []
        @auto_scopes << alias_scope_definition

        singleton_class.send(:alias_method, alias_scope_definition.name, scope_definition.name)
      end
    end
  end
end
