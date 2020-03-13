class CreateFourths < ActiveRecord::Migration[5.2]
  def change
    create_table :fourths do |t|
      t.string :name
      t.references :first, foreign_key: true

      t.timestamps
    end
  end
end
