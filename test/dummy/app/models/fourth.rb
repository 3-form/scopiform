class Fourth < ApplicationRecord
  include Scopiform

  belongs_to :first

  enum status: { inactive: 0, active: 1, discontinued: 2 }
end
