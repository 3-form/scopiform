class Second < ApplicationRecord
  include Scopiform

  belongs_to :first
end
