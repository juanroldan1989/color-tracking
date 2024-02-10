class AddCombinedIndexToActionColors < ActiveRecord::Migration[7.0]
  def change
    add_index :action_colors, [:api_key, :action_id, :color_id]
  end
end
