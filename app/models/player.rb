class Player < ActiveRecord::Base
  
  include BCrypt

  validates :name, uniqueness: true
  has_secure_password

  attr_accessor :position, :keys, :gems, :coins, :steps, :current_level
  
  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def set_variables
    @position = {x: 0, y: 0}
    @keys = 0
    @gems = 0
    @coins = 0
    @steps = 0
    @current_level = 0
  end

  def next_level
    @current_level += 1
  end

  def next_level
    @current_level += 1
  end
  
  def add_step
    @steps += 1
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

  def unlock_door
    @keys -= 1 if @keys >= 1
  end

  def activate_portal
    @gems -= 1 if @gems >= 1
  end

end
