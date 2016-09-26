class MineField
  EASY_SIZE = 10
  MEDIUM_SIZE = 50
  HARD_SIZE = 100

  MINE_PROBABILITY = Array.new(9, false) + [true]

  attr_reader :field
  attr_reader :mask

  def initialize
    set_field
    set_mines
    set_mask
  end

  def set_field
    @field = (0...EASY_SIZE).map do
      (0...EASY_SIZE).map do
        false
      end
    end
  end

  def set_mines
    quota = 10
    while quota.nonzero?
      @field.each do |line|
        line.map! do |mined|
          break if mined || quota.zero?
          mined = MINE_PROBABILITY.sample
          quota -= 1 if mined
        end
      end
    end
  end

  def set_mask
    @mask = @field.map { |line| line.map { true } }
  end

  def unmask(x, y)
    @mask[x][y] = false
    # TODO : unmask adjacent empty cells if empty&neighbourless cell
  end

  def over?
    @mask.all?(&:none?)
  end

  def mine_at?(x, y)
    @field[x][y]
  end

  def valid_move?(x, y)
    x.between?(0, height) && y.between?(0, length) && !@mask[x][y]
  end

  def height
    @field.length
  end

  def length
    @field.first.length
  end
end
