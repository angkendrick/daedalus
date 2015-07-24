# Homepage (Root path)
get '/' do
  erb :index
end

post '/login_signup' do #login rename..
  @name = params[:name].strip
  @password = params[:password].strip
  @existing_player = Player.exists?(name: @name)
  if @existing_player
    @player = Player.find_by(name: @name)
    if @player.password == @password
      session[:id] = @player.id
    else
      @error = "Invalid Password!"
      session[:id] = nil
    end
  else
    @player = Player.new(name: @name, password: @password)
    @error = "Failed to create new player" if !@player.save
    session[:id] = @player.id
  end
  erb :index
end 

post '/new_game' do
  # the map is stored in the database as :map
  # the level of that map is stored as :level
  # The Level class saves the map in Level.new.level
  @player = Player.find(session[:id])
  @player.set_variables
  
  @map = Map.find_by(number: 0).map
  #binding.pry
  @level = Level.new(@map)
  #binding.pry
  strlvl = Level.stringify(@level.level)
  @existing_save = SaveState.exists?(player_id: @player.id)
  if @existing_save
    @current_save = SaveState.find_by(player_id: @player.id)
    @current_save.level = strlvl
    @current_save.save
  else
    @current_save = SaveState.create(player_id: @player.id, map: strlvl, level: 0)
  end
  @current_save.update(
    keys: 0,
    coins: 0,
    gems: 0,
    steps: 0
    )
  @player.update_position(@level.find_start_position)
  @current_save.update(player_position: @player.position.to_s) # saves player start position
  @game = Game.new(@player, @level.level)
  @tiles = @game.tiles_to_html(@level.get_adjacent_tiles(@player.position[:x],@player.position[:y]))
  erb :index
end

post '/load_game' do

end

post '/move' do
  @dir = params[:dir] || "no direction"
  puts @dir
  
  @player = Player.find(session[:id])
  @player.set_variables
  @current_save = SaveState.find_by(player_id: @player.id)
  @position = eval(@current_save.player_position)
  @player.keys = @current_save.keys || 0
  @player.gems = @current_save.gems || 0
  @player.coins = @current_save.coins || 0
  @player.steps = @current_save.steps || 0
  @player.update_position(@position) # TODO this is here until we save the position in saves table
  
  @map = SaveState.find_by(player_id: @player.id).map #Map.find_by(number: 0).level # TODO should be Saves.level_number
  @level = Level.new(@map)
  @game = Game.new(@player, @level)
  #binding.pry
  if @dir == 'left'
    @tiles = @game.move_player(-1, 0)
  elsif @dir == 'right'
    @tiles = @game.move_player(1, 0)
  elsif @dir == 'up'
    @tiles = @game.move_player(0, -1)
  elsif @dir == 'down'
    @tiles = @game.move_player(0, 1)
  end
  #binding.pry
  puts "keys: #{@player.keys} gems: #{@player.gems} coins: #{@player.coins}"
  # player stats
  @current_save.update(
    player_position: @player.position.to_s, 
    level: Level.stringify(@level.level),
    keys: @player.keys,
    coins: @player.coins,
    gems: @player.gems,
    steps: @player.steps
    )
  @current_save.save

  erb :tiles, :layout => false
end
# post 'move' do

# end