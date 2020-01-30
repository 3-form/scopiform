class Third < ApplicationRecord
  include Scopiform

  self.primary_key = :rowid
end
