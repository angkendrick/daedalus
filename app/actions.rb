#require 'routes/game'
#require 'routes/player' 

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



# post 'move' do

# end