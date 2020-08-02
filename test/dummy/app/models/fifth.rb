class Fifth < ApplicationRecord
  include Scopiform

  belongs_to :second
  belongs_to :fourth
  has_one :first, through: :second
end
