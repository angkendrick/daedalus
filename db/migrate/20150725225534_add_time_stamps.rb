class AddTimeStamps < ActiveRecord::Migration
  def change
    add_column(:save_states, :created_at, :datetime)
    add_column(:save_states, :updated_at, :datetime)
  end
end
