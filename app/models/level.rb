class Level

  attr_accessor :level
  def initialize(str)
    @level = Level.arrayify(str)
  end

  def self.load_level(number)
    file = File.open("app/data/levels/level#{number}.txt")
  end

  def self.arrayify(string)
    arr = []
    temp_arr = string.split('|')
    temp_arr.each do |arrx|
      arr << arrx.split(' ')
    end
    arr
  end

  def self.stringify(arr)
    new_array = arr.map do |x|
      x.join(' ')
    end 
    new_array.join("|")
  end

  def change_tile_to(x,y, new_tile)
    self.level[y][x] = new_tile
  end

  def find_start_position
    @level.each_index do |x|
      @level[x].each_index do |y|
        if @level[x][y] == "C"
          pos = { x: y, y: x } 
          return pos
        end
      end
    end
  end

  def get_adjacent_tiles(x, y)
    rows = @level.slice(y-1, 3)
    final_array = []
    rows.each do |arr|
      final_array << arr[x-1] || '#'
      final_array << arr[x] || '#'
      final_array << arr[x+1] || '#'
    end
    final_array
  end



end

# l = Level.new(0)
# arr = Level.arrayify(l.level)
# #l.get_adjacent_tiles(2,2)

# str = Level.stringify(arr)

# print Level.arrayify(str)
