class PlayerTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :password
      t.integer :times_played
      t.time :total_time
      t.time :last_time_stamp
      t.timestamps null: false
    end
  end
end
