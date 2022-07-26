class CreateColors < ActiveRecord::Migration[7.0]
  def change
    create_table :colors do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :colors, :name
  end
end
