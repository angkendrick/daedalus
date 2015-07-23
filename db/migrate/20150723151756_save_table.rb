class SaveTable < ActiveRecord::Migration
  def change

    create_table :save_states do |t|
      t.integer :player_id
      t.string :level
      t.integer :score
      t.integer :keys
      t.integer :gems
      t.integer :coins
      t.boolean :done
      t.integer :steps
      t.string :player_position
    end

  end
end
