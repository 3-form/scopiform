class First < ApplicationRecord
  include Scopiform

  has_many :seconds
  has_many :fourths

  alias_attribute :name_alias, :name
end
