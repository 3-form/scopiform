module Scopiform
  module ReflectionPlugin
    def add_reflection(ar, name, reflection)
      super(ar, name, reflection)

      ar.reflection_added(name, reflection) if ar.respond_to? :reflection_added
    end
  end
end
