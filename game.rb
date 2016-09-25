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
    next if coords.length != 2

    minefield.unmask(*coords)

    MineFieldDisplay.display(minefield)

    break if minefield.mine_at?(*coords) || minefield.over?
  end
rescue Interrupt
  puts ' signal received ; bye !'
end

puts 'Game over'
