class MineFieldHinter

  def self.hint(minefield, x, y)
    hint = 0

    edges = edges(minefield, x, y)

    hint += 1 if !edges.include?(:top) && minefield.field[(x - 1)][y]
    hint += 1 if !edges.include?(:left) && minefield.field[x][(y - 1)]
    hint += 1 if !edges.include?(:bottom) && minefield.field[(x + 1)][y]
    hint += 1 if !edges.include?(:right) && minefield.field[x][(y + 1)]

    hint += 1 if (edges & [:top, :left]).empty? && minefield.field[(x - 1)][(y - 1)]
    hint += 1 if (edges & [:top, :right]).empty? && minefield.field[(x - 1)][(y + 1)]
    hint += 1 if (edges & [:bottom, :left]).empty? && minefield.field[(x + 1)][(y - 1)]
    hint += 1 if (edges & [:bottom, :right]).empty? && minefield.field[(x + 1)][(y + 1)]

    hint
  end

  # Returns array with adjactent edges : :top, :left, :bottom, :right  
  def self.edges(minefield, x, y)
    edges = []
    edges << :top    if x.zero?
    edges << :left   if y.zero?
    edges << :bottom if x == minefield.height - 1
    edges << :right  if y == minefield.length - 1
    edges
  end
end
