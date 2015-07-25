class Message < ActiveRecord::Base

  validates :player_id, presence: true
  validates :position, presence: true
  validates :level_number, presence: true
  validates :content, presence: true

  def self.get_message_at(xy, level_number)
    self.find_by(position: xy.to_s, level_number: level_number)
  end

end