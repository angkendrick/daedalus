class Player < ActiveRecord::Base

  attr_accessor :position
  @position = {x: 0, y: 0}
  
  def update_position(xy = {})
    @position = xy
  end

  def move(dirx, diry, game)
    #ask game if we can move there: Game.cimh?(@position[:x] + dirx, @position[:y] + diry)
    # if true
    # update_playerposition(@position[:x] +dirx, @position[:y] + diry)

  end

end