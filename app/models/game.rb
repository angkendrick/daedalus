class Game

  attr_accessor :player, :level
  
  def initialize(player, level)
    @player = player
    @level = level
  end

  def move_player(dirx, diry)
    x = @player.position[:x] + dirx
    y = @player.position[:y] + diry
    if self.can_i_move_here(x, y)
      
      @player.update_position({x: x, y: y})
    end
    tiles = @level.get_adjacent_tiles(x, y)
    tiles_to_html(tiles)
  end

  def can_i_move_here(x, y)
    str = @level[y][x] 
    case str
      when '-'
        return true
      when '#'
        return false
      when 'P'
        return true
      when 'D'
        return true
      when 'G'
        return true
      when 'T'
        return true
      when 'K'
        return true
      when nil
        return false
    end 
  end

  def tiles_to_html(arr)
    html_arr = []
    end_str = "<div class='tile_row'>"
    count = 0;
    arr.each do |str|
      case str
        when '-'
          end_str += default_div('walkable')
        when '#'
          end_str += default_div('wall')
        when 'P'
          end_str += default_div('portal')
        when 'D'
          end_str += default_div('door')
        when 'G'
          end_str += default_div('gem')
        when 'T'
          end_str += default_div('coin')
        when 'K'
          end_str += default_div('key')
        
      end
      count += 1
      if count % 3 == 0
        end_str += "</div>"
        end_str += "<div class='tile_row'>" if count < arr.count
      end

    end
    puts end_str
    end_str
  end

  private
  def default_div(class_var)
    "<div class='#{class_var} inline'></div>"
  end

end