# frozen_string_literal: true

require 'active_support/concern'

module Scopiform
  module Filters
    extend ActiveSupport::Concern

    module ClassMethods
      def apply_filters(filters_hash, injecting: all, joins: nil)
        filters_hash.keys.inject(injecting) { |out, filter_name| resolve_filter(out, filter_name, filters_hash[filter_name], joins) }
      end

      def apply_sorts(sorts_hash, injecting = all)
        sorts_hash.keys.inject(injecting) { |out, sort_name| resolve_sort(out, sort_name, sorts_hash[sort_name]) }
      end

      private

      def resolve_filter(out, filter_name, filter_argument, joins)
        if filter_name.to_s.casecmp('OR').zero?
          or_joins = {}

          return (
            filter_argument
              .map { |or_filters_hash| apply_filters(or_filters_hash, injecting: out, joins: or_joins) }
              .map { |a| a.scopiform_joins(or_joins) }
              .inject { |chain, applied| chain.or(applied) }
          )
        end
        out.send(filter_name, filter_argument, joins: joins)
      end

      def resolve_sort(out, sort_name, sort_argument)
        method_name = "sort_by_#{sort_name}"
        out.send(method_name, sort_argument)
      end
    end
  end
end
