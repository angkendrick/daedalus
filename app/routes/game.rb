#game new
#game load

get '/game/' do
  erb :'game/index'
end

get '/game/highscore' do
  #binding.pry
  @highscore = Highscore.all.order(highscore: :desc).limit(10)
  erb :'game/highscore'
end

get '/game/logout' do
  session[:id] = nil
  redirect :'/'
end

post '/game/new' do
  # the map is stored in the database as :map
  # the level of that map is stored as :level
  # The Level class saves the map in Level.new.level
  @player = Player.find(session[:id])
  @player.set_variables
  
  @map = Map.find_by(number: 0).level
  #binding.pry
  @player.set_variables 
  @level = Level.new(@map)
  strlvl = Level.stringify(@level.level)
  print strlvl
  @existing_save = SaveState.exists?(player_id: @player.id)
  if @existing_save
    @current_save = SaveState.find_by(player_id: @player.id)
    @current_save.map = strlvl
    @current_save.current_level = 0
    @current_save.save
  else
    @current_save = SaveState.create(player_id: @player.id, map: strlvl, current_level: 0)
  end
  @current_save.update(
    keys: 0,
    coins: 0,
    gems: 0,
    steps: 0
    )
  @player.update_position(@level.find_start_position)
  @current_save.update(player_position: @player.position.to_s) # saves player start position
  @game = Game.new(@player, @level)
  @tiles = @game.tiles_to_html(@level.get_adjacent_tiles(@player.position[:x],@player.position[:y]))
  erb :'/game/index'
end

post '/game/load' do
  @player = Player.find(session[:id])
  @existing_save = SaveState.exists?(player_id: @player.id)
  if @existing_save
    @current_save = SaveState.find_by(player_id: @player.id)
    @position = eval(@current_save.player_position)
    @player.update_position(@position)
    @map = @current_save.map
    @level = Level.new(@map)
    @game = Game.new(@player, @level.level)
    @tiles = @game.tiles_to_html(@level.get_adjacent_tiles(@player.position[:x],@player.position[:y]))
  else
    #no saved game found
  end
  erb :'/game/index'
end

post '/game/move' do
  time_start = Time.now
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
  @player.current_level = @current_save.current_level || 0
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
  else
    @tiles = @game.move_player(0,0)
  end
  # find messages
  @messages = Message.find_by(position: @player.position.to_s, level_number: @player.current_level)
  if @messages
    @tiles += "<div id='message_list'>"
    @messages = Message.where(position: @player.position.to_s, level_number: @player.current_level)
    @messages.each do |m|
      name = Player.find(m.player_id).name
      @tiles += "<div class='message_item'>#{name}: #{m.content}</div>"
    end
    @tiles += "</div>"
  end
  # @tiles = ""
  # player stats
  @score = @game.calculate_score
  #binding.pry
  @score = [@score || 0, @current_save.score || 0].max #always get the highest score
  @current_save.update(
    player_position: @player.position.to_s, 
    map: Level.stringify(@game.level.level),
    current_level: @player.current_level,
    keys: @player.keys,
    coins: @player.coins,
    gems: @player.gems,
    steps: @player.steps,
    score: @score
    )
  @current_save.save
  #binding.pry
  if @game.finished
    Highscore.create(player_id: @player.id, name: @player.name, highscore: @current_save.score)
  end
  time_end = Time.now
  puts "operation time: #{time_end - time_start}"
  erb :tiles, :layout => false
  
end

post '/game/leave_message' do
  #binding.pry
  @player = Player.find(session[:id])
  @current_save = SaveState.find_by(player_id: session[:id])
  @position = @current_save.player_position
  @message = params[:message]
  # find if there is a message at this position
  # and from this player already.
  #binding.pry
  if !Message.exists?(player_id: @player.id, level_number: @current_save.current_level) #does not exist
    Message.create(player_id: @player.id, position: @position, level_number: @current_save.current_level, content: @message)
  else # 
    @message_save = Message.find_by(player_id: @player.id, level_number: @current_save.current_level) #update message
    #binding.pry
    @message_save.update(
      position: @position,
      level_number: @current_save.current_level,
      content: @message
    )
    @message_save.save!
  end

  puts "message from player: #{@message}"
end











