class MineFieldHinter

  # Returns number of adjacent mines
  def self.hint(minefield, x, y)
    neighbours(minefield, x, y).count do |neighbour_x, neighbour_y|
      minefield.mine_at?(neighbour_x, neighbour_y)
    end
  end

  # Returns array with coords of adjacent cells
  def self.neighbours(minefield, x, y)
    edges = edges(minefield, x, y)

    orthogonal_neighbours(x, y, edges) + diagonal_neighbours(x, y, edges)
  end

  def self.orthogonal_neighbours(x, y, edges)
    neighbours = []
    neighbours << [(x - 1), y] unless edges.include?(:top)
    neighbours << [x, (y - 1)] unless edges.include?(:left)
    neighbours << [(x + 1), y] unless edges.include?(:bottom)
    neighbours << [x, (y + 1)] unless edges.include?(:right)
    neighbours
  end

  def self.diagonal_neighbours(x, y, edges)
    neighbours = []
    neighbours << [(x - 1), (y - 1)] if (edges & [:top, :left]).empty?
    neighbours << [(x - 1), (y + 1)] if (edges & [:top, :right]).empty?
    neighbours << [(x + 1), (y - 1)] if (edges & [:bottom, :left]).empty?
    neighbours << [(x + 1), (y + 1)] if (edges & [:bottom, :right]).empty?
    neighbours
  end

  # Returns array with adjacent edges : :top, :left, :bottom, :right
  def self.edges(minefield, x, y)
    edges = []
    edges << :top    if x.zero?
    edges << :left   if y.zero?
    edges << :bottom if x == minefield.height - 1
    edges << :right  if y == minefield.length - 1
    edges
  end

  def self.masked_neighbourhood(minefield, x, y)
    neighbours(minefield, x, y).select do |neighbour_x, neighbour_y|
      minefield.mask_at?(neighbour_x, neighbour_y)
    end
  end

  # Unmask around cell
  def self.discover_around(minefield, x, y)
    return if minefield.mine_at?(x,y) || hint(minefield, x, y).nonzero?

    masked_neighbourhood(minefield, x, y).each do |neighbour_x, neighbour_y|
      minefield.unmask(neighbour_x, neighbour_y, false)
      discover_around(minefield, neighbour_x, neighbour_y)
    end
  end

  def self.scan_for_coords(coords, array)
    array.map(&:join).include?(coords.join)
  end
end
