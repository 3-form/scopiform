class Sixth < ApplicationRecord
  include Scopiform

  belongs_to :fifth
  has_one :first, through: :fifth
  belongs_to :second, primary_key: %i[name number], foreign_key: %i[second_name second_number]
end
