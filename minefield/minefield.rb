class SteppedOnMine < Exception ; end
class Win < Exception ; end

class MineField
  EASY_SIZE = 10
  MEDIUM_SIZE = 50
  HARD_SIZE = 100

  MINE_PROBABILITY = Array.new(9, false) + [true]

  attr_reader :field
  attr_reader :mask

  def initialize(level = 'easy', mines_quota = nil)
    @size = case level
      when 'easy'   then EASY_SIZE
      when 'medium' then MEDIUM_SIZE
      when 'hard'   then HARD_SIZE
    end
    @mines_quota = mines_quota || @size
    set_field
    set_mines
    set_mask
  end

  def set_field
    @field = (0...@size).map do
      (0...@size).map do
        false
      end
    end
  end

  def set_mines
    quota = @mines_quota
    while quota.nonzero?
      @field.each_with_index do |line, x|
        line.each_with_index do |mined, y|
          break if mined || quota.zero?
          mined = MINE_PROBABILITY.sample
          quota -= 1 if mined
          @field[x][y] = mined
        end
      end
    end
  end

  def set_mask
    @mask = @field.map { |line| line.map { true } }
  end

  def unmask(x, y, discover = true)
    @mask[x][y] = false
    MineFieldHinter.discover_around(self, x, y) if discover
  end

  def play_at(x,y)
    unmask(x, y)
    raise SteppedOnMine if mine_at?(x,y)
    raise Win if over?
  end

  def remove_mask
    @mask.map! { |line|
      line.map {
        false
      }
    }
  end

  def over?
    scan_field(false).all? { |x, y|
      @mask[x][y] == false
    }
  end

  def mine_at?(x, y)
    @field[x][y]
  end

  def mask_at?(x, y)
    @mask[x][y]
  end

  def scan_field(with_mines = true)
    cells = []
    @field.each_with_index do |line, x|
      line.each_with_index do |mined, y|
        cells << [x, y] if (with_mines && mined) || (!with_mines && !mined)
      end
    end
    cells
  end


  def valid_move?(x, y)
    x.between?(0, height) && y.between?(0, length)
  end

  def height
    @field.length
  end

  def length
    @field.first.length
  end
end
