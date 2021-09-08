# frozen_string_literal: true

require 'active_support/concern'

module Scopiform
  module Helpers
    extend ActiveSupport::Concern

    STRING_TYPES = %i[string text].freeze
    NUMBER_TYPES = %i[integer float decimal].freeze
    DATE_TYPES = %i[date time datetime timestamp].freeze

    module ClassMethods
      def attribute_aliases
        alias_hash = super

        key = primary_key.to_s
        alias_hash = alias_hash.merge('id' => key) if key != 'id'

        alias_hash
      end

      def attribute_aliases_inverted
        attribute_aliases.each_with_object({}) { |(k, v), o| (o[v] ||= []) << k }
      end

      def resolve_alias(name)
        name_str = name.to_s
        return attribute_aliases[name_str] if attribute_aliases[name_str].present?

        name_str
      end

      def aliases_for(name)
        attribute_aliases_inverted[name.to_s] || []
      end

      def column(name)
        name = resolve_alias(name)
        safe_columns_hash[name.to_s]
      end

      def association(name)
        name = resolve_alias(name)
        association = reflect_on_association(name)

        association.klass if association.present? && !association.polymorphic?
        association
      rescue NameError
        logger.warn "Unable to load class for association `#{name}` in model `#{self.name}`"
        nil
      end

      def enum_attribute?(name)
        defined_enums.include? name.to_s
      end

      def scopiform_arel(ctx)
        ctx&.arel_table || arel_table
      end

      protected

      def safe_columns
        @safe_columns ||= columns
      rescue *safe_column_rescue_errors
        logger.warn "Unable to load columns for `#{name}`"
        @safe_columns = []
      end

      def safe_columns_hash
        @safe_columns_hash ||= columns_hash
      rescue *safe_column_rescue_errors
        logger.warn "Unable to load columns_hash for `#{name}`"
        @safe_columns_hash = {}
      end

      private

      def safe_column_rescue_errors
        [
          ActiveRecord::StatementInvalid,
          Object.const_defined?('TinyTds') ? TinyTds::Error : nil,
        ]
      end
    end
  end
end
