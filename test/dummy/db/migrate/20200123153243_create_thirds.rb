class CreateThirds < ActiveRecord::Migration[5.2]
  def change
    create_table :thirds do |t|
      t.string :rowid
      t.string :name

      t.timestamps
    end
  end
end
