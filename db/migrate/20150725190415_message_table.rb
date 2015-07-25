class MessageTable < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :player_id
      t.string :position
      t.integer :level_number
      t.string :content
      t.timestamps null: false
    end
  end
end
