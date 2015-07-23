class LevelsTable < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :level
      t.integer :number
    end
  end
end
