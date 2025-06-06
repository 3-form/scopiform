module Scopiform
  class ScopeContext
    attr_accessor :association, :arel_table, :association_arel_table, :joins, :ancestors, :scopes, :has_manys

    def self.from(ctx)
      created = new

      if ctx
        created.set(ctx.arel_table)
        created.association = ctx.association
        created.association_arel_table = ctx.association_arel_table
        created.joins = ctx.joins
        created.ancestors = [*ctx.ancestors]
      end

      created
    end

    def initialize
      @joins = []
      @ancestors = []
      @scopes = []
      @has_manys = []
    end

    def set(arel_table)
      @arel_table = arel_table

      self
    end

    def build_joins
      loop do
        if association.through_reflection
          source_reflection_name = association.source_reflection_name
          self.association = association.through_reflection
        end

        unless association.has_one? || association.belongs_to?
          has_manys << association.name
        end

        ancestors << association.name.to_s.pluralize
        self.association_arel_table = association.klass.arel_table.alias(alias_name)

        joins << create_join

        if association.scope.present? && association.scope.arity.zero?
          association.klass.scopiform_ctx = ScopeContext.from(self).set(association_arel_table)
          scopes << association.klass.instance_exec(&association.scope)
          association.klass.scopiform_ctx = nil
        end

        break if source_reflection_name.blank?

        self.association = association.klass.reflect_on_association(source_reflection_name)
        self.arel_table = association_arel_table
      end

      joins
    end

    def alias_name
      ancestors.join('_').downcase
    end

    private

    def conditions
      [*association.join_foreign_key]
        .zip([*association.join_primary_key])
        .map { |foreign, primary| arel_table[foreign].eq(association_arel_table[primary]) }
        .reduce { |acc, cond| acc.and(cond) }
    end

    def create_join
      arel_table.create_join(
        association_arel_table,
        association_arel_table.create_on(conditions),
        Arel::Nodes::OuterJoin
      )
    end
  end
end
