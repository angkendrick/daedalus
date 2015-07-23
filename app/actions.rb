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
  @player = Player.find(session[:id])
  @level = Level.new(0)
  strlvl = Level.stringify(@level.level)

  @existing_save = SaveState.exists?(player_id: @player.id)
  if @existing_save
    @current_save = SaveState.find_by(player_id: @player.id)
    @current_save.level = strlvl
    @current_save.save
  else
    SaveState.create(player_id: @player.id, level: strlvl)
  end
  
  @player.update_position(@level.find_start_position)
  @game = Game.new(@player, @level.level)
  @tiles = @game.tiles_to_html(@level.get_adjacent_tiles(7,3))
  erb :index
end

post '/load_game' do

end

post '/move' do
  @dir = params[:dir] || "no direction"
  puts @dir

  @player = Player.find(session[:id])
  @player.update_position({x: 7, y: 3})
  @level = Level.arrayify(SaveState.find_by(player_id: @player.id).level)
  @game = Game.new(@player, @level)
  if @dir == 'left'
    @tiles = @game.move_player(-1, 0)
  end
  erb :index
end
# post 'move' do

# end