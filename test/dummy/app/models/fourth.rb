class Fourth < ApplicationRecord
  include Scopiform

  belongs_to :first
end
