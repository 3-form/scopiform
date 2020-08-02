class CreateFifths < ActiveRecord::Migration[6.0]
  def change
    create_table :fifths do |t|
      t.string :name
      t.references :second, foreign_key: true
      t.references :fourth, foreign_key: true

      t.timestamps
    end
  end
end
