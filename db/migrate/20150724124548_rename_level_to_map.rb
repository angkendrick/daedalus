class RenameLevelToMap < ActiveRecord::Migration
  def change
    rename_column :save_states, :level, :map
    add_column :save_states, :current_level, :integer
  end
end
