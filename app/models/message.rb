class Message < ActiveRecord::Base

  validates :player_id, presence: true
  validates :position, presence: true
  validates :level_number, presence: true
  validates :content, presence: true

end