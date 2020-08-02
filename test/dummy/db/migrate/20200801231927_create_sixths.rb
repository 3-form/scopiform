class CreateSixths < ActiveRecord::Migration[6.0]
  def change
    create_table :sixths do |t|
      t.string :name
      t.string :second_name
      t.integer :second_number
      t.references :fifth, foreign_key: true

      t.timestamps
    end
  end
end
