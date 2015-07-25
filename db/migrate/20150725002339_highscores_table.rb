class HighscoresTable < ActiveRecord::Migration
  def change
    create_table :highscores do |t|
      t.integer :player_id
      t.string :name
      t.integer :highscore
      t.timestamps null: false
    end
  end
end
