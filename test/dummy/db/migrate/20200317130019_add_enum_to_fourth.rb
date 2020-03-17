class AddEnumToFourth < ActiveRecord::Migration[6.0]
  def change
    add_column :fourths, :status, :integer
  end
end
