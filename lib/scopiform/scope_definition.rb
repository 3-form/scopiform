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
      "#{prefix}#{attribute}#{suffix}".underscore
    end
  end
end
