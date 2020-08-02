# frozen_string_literal: true

require 'active_support/concern'
require 'scopiform/scope_context'

module Scopiform
  module Filters
    extend ActiveSupport::Concern

    module ClassMethods
      def apply_filters(filters_hash, injecting: all, ctx: nil)
        filters_hash.keys.inject(injecting) { |out, filter_name| resolve_filter(out, filter_name, filters_hash[filter_name], ctx: ctx) }
      end

      def apply_sorts(sorts_hash, injecting = all, ctx: nil)
        sorts_hash.keys.inject(injecting) { |out, sort_name| resolve_sort(out, sort_name, sorts_hash[sort_name], ctx: ctx) }
      end

      private

      def resolve_filter(out, filter_name, filter_argument, ctx:)
        if filter_name.to_s.casecmp('OR').zero?
          ctx ||= ScopeContext.new
          ctx.joins = []

          return (
            filter_argument
              .map { |or_filters_hash| apply_filters(or_filters_hash, injecting: out, ctx: ctx) }
              .map { |a| a.joins(ctx.joins) }
              .inject { |chain, applied| chain.or(applied) }
          )
        end
        out.send(filter_name, filter_argument, ctx: ctx)
      end

      def resolve_sort(out, sort_name, sort_argument, ctx:)
        method_name = "sort_by_#{sort_name}"
        out.send(method_name, sort_argument, ctx: ctx)
      end
    end
  end
end
