class Player < ActiveRecord::Base

  attr_accessor :position
  attr_reader :keys, :gems, :coins
  
  def set_variables
    @position = {x: 0, y: 0}
    @keys = 0
    @gems = 0
    @coins = 0
  end

  def update_position(xy = {})
    @position = xy
  end

  def pick_up_key
    @keys = @keys + 1
  end

  def pick_up_gem
    @gems = @gems + 1
  end

  def pick_up_coin
    @coins = @coins + 1
  end

  def activate_portal
    @gems -= 1 if @gems >= 1
  end


end