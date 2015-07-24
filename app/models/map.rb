class Map < ActiveRecord::Base

  def self.find_next_map(number)
    if Map.exists?(number: number)
      Map.find_by(number: number).level
    end
  end

end