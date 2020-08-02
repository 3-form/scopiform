module Scopiform
  class ScopeDefinition
    attr_accessor :attribute, :prefix, :suffix, :options

    def initialize(attribute, prefix: nil, suffix: nil, **options)
      @attribute = attribute.to_sym
      @prefix = prefix
      @suffix = suffix
      @options = options
    end

    def name
      name_for(attribute)
    end

    def name_for(attribute_name)
      "#{prefix}#{attribute_name}#{suffix}".underscore.to_sym
    end

    def dup
      duplicate = super
      duplicate.options = options.dup

      duplicate
    end
  end
end
