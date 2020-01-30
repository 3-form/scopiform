class First < ApplicationRecord
  include Scopiform

  alias_attribute :name_alias, :name
end
