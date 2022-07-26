class CreateActionColors < ActiveRecord::Migration[7.0]
  def change
    create_table :action_colors do |t|
      t.integer :user_id, null: false
      t.integer :action_id, null: false
      t.integer :color_id, null: false
      t.integer :amount, null: false, default: 0

      t.timestamps
    end

    add_index :action_colors, :user_id
    add_index :action_colors, :action_id
    add_index :action_colors, :color_id
    add_index :action_colors, :amount
  end
end
