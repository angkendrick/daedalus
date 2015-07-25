class Message < ActiveRecord::Base

  def self.get_message_at(xy, level_number)
    self.find_by(position: xy.to_s, level_number: level_number)
  end
end