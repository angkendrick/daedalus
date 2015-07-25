class Game

  attr_accessor :player, :level, :finished
  
  def initialize(player, level)
    @player = player
    @level = level
    @finished = false
  end

  def move_player(dirx, diry)
    x = @player.position[:x] + dirx
    y = @player.position[:y] + diry
    #binding.pry
    if self.can_i_move_here?(x, y)

      if(@level.level[y][x] == "P")
        @player.update_position(@player.update_position({x: x, y: y}))
        @player.update_position(@level.find_next_portal(@player.position[:x], @player.position[:y]))
        
      elsif(@level.level[y][x] == "E")
        @player.next_level
        map = Map.find_by(number: @player.current_level)
        if map
          # load new level to the saves table
          self.level = Level.new(map.level)
          # find start position
          pos = self.level.find_start_position
          puts "new level position: #{pos}"
          # move player to start position
          @player.update_position(pos)
        else
          return finish_maze
        end
      else
        @player.update_position({x: x, y: y})
      end
    
      @player.add_step
      @level.change_tile_to(@player.position[:x], @player.position[:y], '-')
    end
    puts "player position: #{@player.position}"
    #calculate score
    tiles = @level.get_adjacent_tiles(@player.position[:x], @player.position[:y])
    tiles_to_html(tiles)
  end

  def can_i_move_here?(x, y)
    #binding.pry
    str = @level.level[y][x] 
    case str
      when '-'
        return true
      when '#'
        return false
      when 'P'
        if @player.gems > 0
          @player.activate_portal
          return true
        else
          return false
        end
      when 'D'
        if @player.keys > 0
          @player.unlock_door
          return true
        else
          return false
        end
      when 'G'
        @player.pick_up_gem
        return true
      when 'T'
        @player.pick_up_coin
        return true
      when 'K'
        @player.pick_up_key
        return true
      when 'E'
        # check if there is a new level
        
      
        true
      when nil
        return false
    end 
  end

  def tiles_to_html(arr)
    outer_wrapper = "<div class='outer_game_wrapper'>"
    wrapper_start = "<div class='map_wrapper'>"
    tiles = "<div class='tile_row'>"
    count = 0
    count_y = 0
    arr.each do |str|
      case str
        when '-'
          tiles += default_div('walkable', count % 3, count_y )
        when '#'
          tiles += default_div('wall', count % 3, count_y )
        when 'P'
          tiles += default_div('portal', count % 3, count_y )
        when 'D'
          tiles += default_div('door', count % 3, count_y )
        when 'G'
          tiles += default_div('gem', count % 3, count_y )
        when 'T'
          tiles += default_div('coin', count % 3, count_y )
        when 'K'
          tiles += default_div('key', count % 3, count_y )
        when 'C'
          tiles += default_div('player', count % 3, count_y )
        when 'E'
          tiles += default_div('exit', count % 3, count_y )
        else
          tiles += default_div('outside', count % 3, count_y )
      end
      count += 1

      if count % 3 == 0
        count_y += 1
        tiles += "</div>"
        tiles += "<div class='tile_row'>" if count < arr.count
      end

    end

    end_div = "</div>"
    inventory_wrap_start = "<div class='inventory_wrapper'>"
    row_wrap_start = "<div class='inventory_row'>"
    keys = "#{row_wrap_start}<div class='keys_icon inventory_icon'></div><div class='keys_amount inventory_amount'>#{@player.keys}</div>#{end_div}"
    gems = "#{row_wrap_start}<div class='gems_icon inventory_icon'></div><div class='gems_amount inventory_amount'>#{@player.gems}</div>#{end_div}"
    coins = "#{row_wrap_start}<div class='coins_icon inventory_icon'></div><div class='coins_amount inventory_amount'>#{@player.coins}</div>#{end_div}"
    steps = "#{row_wrap_start}<div class='steps_icon inventory_icon'></div><div class='steps_amount inventory_amount'>#{@player.steps}</div>#{end_div}"
    wrapper_start + tiles + end_div + inventory_wrap_start + keys + gems + coins + steps + end_div
  end

  def calculate_score
    total = 0
    total = (((@player.current_level + 1) * 100) + (@player.coins * 10) + (@player.gems * 50) - @player.steps)
  end

  private
  def default_div(class_var, x_offset, y_offset)
    x = @player.position[:x] + x_offset - 1
    y = @player.position[:y] + y_offset - 1
    message = Message.get_message_at({ x: x, y: y }, @player.current_level)
    other_player = SaveState.find_by(["player_id != ? and player_position = ? and current_level = ? and updated_at > ?", @player.id, {x: x, y: y}.to_s, @player.current_level, Time.now - 10])
    other_player_name = Player.find_by(id: other_player.player_id).name
    "<div class='#{class_var} #{'message' if message} #{'player' if other_player} inline'>#{other_player_name if other_player}</div>"
  end

  def finish_maze
    @finished = true
    "<div id='end_screen'>You have crawled out of Daedalus Maze into freedom. Your final score is #{calculate_score}</div>"
  end

end