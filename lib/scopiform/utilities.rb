require 'scopiform/scope_context'

module Scopiform
  module Utilities
    def self.cast_to_text(arel_column, connection)
      cast_to = connection.adapter_name.downcase.starts_with?('mysql') ? 'CHAR' : 'TEXT'
      Arel::Nodes::NamedFunction.new(
        'CAST',
        [arel_column.as(cast_to)]
      )
    end

    def self.association_scope(active_record, association, method, value, ctx:)
      is_root = ctx.nil?
      ctx = ScopeContext.from(ctx)
      ctx.set(active_record.arel_table) if is_root || ctx.arel_table.blank?

      ctx.association = association
      ctx.build_joins
      has_manys = ctx.has_manys.present?

      applied = ctx.association.klass.send(method, value, ctx: ScopeContext.from(ctx).set(ctx.association_arel_table))

      if is_root && !has_manys
        ctx.scopes.reduce(active_record.joins(ctx.joins).merge(applied)) { |chain, scope| chain.merge(scope) }
      elsif is_root && has_manys
        ctx.scopes.reduce(active_record.distinct.joins(ctx.joins).merge(applied)) { |chain, scope| chain.merge(scope) }
      else
        ctx.scopes.reduce(active_record.all.merge(applied)) { |chain, scope| chain.merge(scope) }
      end
    end

    def self.truthy_hash(hash)
      hash.values.find { |value| value.is_a?(Hash) ? truthy_hash(value) : value.present? }
    end
  end
end
