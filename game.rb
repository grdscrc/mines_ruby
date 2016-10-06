#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'minefield/minefield')
require File.join(File.dirname(__FILE__), 'minefield/display')

# Syntax : <x><not number><y>
SYNTAX_REGEX = /(\d+)\D+(\d+)/

minefield = MineField.new

begin
  MineFieldDisplay.display(minefield)

  while gets
    input = $_.strip
    next if input.empty?
    match = input.match(SYNTAX_REGEX)
    coords = match.captures.map(&:to_i) if match
    if match.nil? || !minefield.valid_move?(*coords)
      MineFieldDisplay.say 'Invalid move ; syntax is "<x> <y>"'
      next
    end

    minefield.play_at(*coords)

    MineFieldDisplay.display(minefield)
  end
rescue SteppedOnMine
  MineFieldDisplay.explode
rescue Win
  MineFieldDisplay.congratulate
rescue Interrupt
  MineFieldDisplay.wave_bye
end

minefield.remove_mask
MineFieldDisplay.display(minefield)
