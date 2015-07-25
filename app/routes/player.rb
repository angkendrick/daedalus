#player login
#player signup
#player logout
#player delete_player
#player update
#player move

require 'bcrypt'

helpers do

  def two_words_match?(string1, string2)
    string1 == string2
  end

end

get '/signup' do
  @player = Player.new
  erb :'player/signup' 

end

get '/login' do
  @player = Player.new
  erb :'player/login'
end


post '/signup' do
  if two_words_match?(params[:password], params[:password2])
    @player = Player.new(name: params[:name].strip, password: params[:password])       
    if @player.save
      session[:id] = @player.id
      redirect :'game/' 
    else
      erb :'player/signup'
    end
  else
    @player = nil
    @error = "passwords don't match!"
    erb :'player/signup'
  end
end

post '/login' do
  @player = Player.find_by(name: params[:name].strip)
  puts "entering if"
  if @player
    # binding.pry
    if @player.password == params[:password]
      session[:id] = @player.id
      puts "authenticated"
      redirect :'game/'
    else
      puts "failed password"
      @error = "Invalid username / password"
      puts "failed password1"
      erb :'player/login'
    end
  else
    @error = "Invalid username / password"
    erb :'player/login'
  end

end
