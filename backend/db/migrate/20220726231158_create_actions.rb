class CreateActions < ActiveRecord::Migration[7.0]
  def change
    create_table :actions do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :actions, :name, unique: true
  end
end
