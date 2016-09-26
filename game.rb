#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'minefield/minefield')
require File.join(File.dirname(__FILE__), 'minefield/display')

minefield = MineField.new

begin
  MineFieldDisplay.display(minefield)

  while gets
    input = $_.strip
    next if input.empty?
    coords = input.split(';').first(2).map(&:to_i)
    if coords.length != 2 || minefield.valid_move?(*coords)
      MineFieldDisplay.say 'Invalid move ; syntax is "<x>;<y>"'
      next
    end

    minefield.unmask(*coords)

    MineFieldDisplay.display(minefield)

    break if minefield.mine_at?(*coords) || minefield.over?
  end
rescue Interrupt
  MineFieldDisplay.say 'Interrupt signal received ; bye !'
end

minefield.remove_mask
MineFieldDisplay.display(minefield)
MineFieldDisplay.say 'Game over'
