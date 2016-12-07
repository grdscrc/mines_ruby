#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'minefield/minefield')
require File.join(File.dirname(__FILE__), 'minefield/display')

# Syntax : <x><not number><y>
SYNTAX_REGEX = /(\d+)\D+(\d+)/

minefield = MineField.new
display = Display.new(minefield)

begin
  display.refresh

  while gets
    input = $_.strip
    next if input.empty?
    match = input.match(SYNTAX_REGEX)
    coords = match.captures.map(&:to_i) if match
    if match.nil? || !minefield.valid_move?(*coords)
      display.warn_error
      next
    end

    minefield.play_at(*coords)
    display.signal_move(*coords)

    display.refresh
  end
rescue SteppedOnMine
  display.explode
rescue Win
  display.congratulate
rescue Interrupt
  display.wave_bye
end

minefield.remove_mask
display.refresh
