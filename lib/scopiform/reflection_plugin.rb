module Scopiform
  module ReflectionPlugin
    def add_reflection(record, name, reflection)
      super(record, name, reflection)

      record.reflection_added(name, reflection) if record.respond_to? :reflection_added
    end
  end
end
