class CreateFirsts < ActiveRecord::Migration[5.2]
  def change
    create_table :firsts do |t|
      t.string :name

      t.timestamps
    end
  end
end
