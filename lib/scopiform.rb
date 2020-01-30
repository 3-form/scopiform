require 'scopiform/helpers'
require 'scopiform/core'
require 'scopiform/common_scopes'
require 'scopiform/string_number_scopes'
require 'scopiform/string_number_date_scopes'
require 'scopiform/association_scopes'
require 'scopiform/reflection_plugin'
require 'scopiform/filters'

module Scopiform
  def self.included(base)
    base.class_eval do
      include Scopiform::Helpers
      include Scopiform::Core
      include Scopiform::CommonScopes
      include Scopiform::StringNumberScopes
      include Scopiform::StringNumberDateScopes
      include Scopiform::AssociationScopes
      include Scopiform::Filters
    end
  end
end

ActiveRecord::Reflection.singleton_class.prepend Scopiform::ReflectionPlugin
