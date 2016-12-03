class Hinter

  attr_reader :field

  def initialize(minefield)
    @minefield = minefield
    set_hints
  end

  def hint(x, y)
    @field[x][y]
  end

  def set_hints
    size = @minefield.length
    @field = (0...size).map do |x|
      (0...size).map do |y|
        calculate_hint(x, y)
      end
    end
  end

  # Returns number of adjacent mines
  def calculate_hint(x, y)
    neighbours(x, y).count do |neighbour_x, neighbour_y|
      @minefield.mine_at?(neighbour_x, neighbour_y)
    end
  end

  # Returns array with coords of adjacent cells
  def neighbours(x, y)
    edges = edges(x, y)

    orthogonal_neighbours(x, y, edges) + diagonal_neighbours(x, y, edges)
  end

  def orthogonal_neighbours(x, y, edges)
    neighbours = []
    neighbours << [(x - 1), y] unless edges.include?(:top)
    neighbours << [x, (y - 1)] unless edges.include?(:left)
    neighbours << [(x + 1), y] unless edges.include?(:bottom)
    neighbours << [x, (y + 1)] unless edges.include?(:right)
    neighbours
  end

  def diagonal_neighbours(x, y, edges)
    neighbours = []
    neighbours << [(x - 1), (y - 1)] if (edges & [:top, :left]).empty?
    neighbours << [(x - 1), (y + 1)] if (edges & [:top, :right]).empty?
    neighbours << [(x + 1), (y - 1)] if (edges & [:bottom, :left]).empty?
    neighbours << [(x + 1), (y + 1)] if (edges & [:bottom, :right]).empty?
    neighbours
  end

  # Returns array with adjacent edges : :top, :left, :bottom, :right
  def edges(x, y)
    edges = []
    edges << :top    if x.zero?
    edges << :left   if y.zero?
    edges << :bottom if x == @minefield.height - 1
    edges << :right  if y == @minefield.length - 1
    edges
  end

  def masked_neighbourhood(x, y)
    neighbours(x, y).select do |neighbour_x, neighbour_y|
      @minefield.mask_at?(neighbour_x, neighbour_y)
    end
  end

  # Unmask around cell
  def discover_around(x, y)
    return if @minefield.mine_at?(x, y) || hint(x, y).nonzero?

    masked_neighbourhood(x, y).each do |neighbour_x, neighbour_y|
      @minefield.unmask(neighbour_x, neighbour_y, false)
      discover_around(@minefield, neighbour_x, neighbour_y)
    end
  end

  def scan_for_coords(coords, array)
    array.map(&:join).include?(coords.join)
  end
end
