class CreateSeconds < ActiveRecord::Migration[5.2]
  def change
    create_table :seconds do |t|
      t.references :first, foreign_key: true
      t.string :name
      t.date :date
      t.integer :number
      t.boolean :boolean

      t.timestamps
    end
  end
end
