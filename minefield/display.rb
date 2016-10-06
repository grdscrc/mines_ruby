# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'hinter')

class MineFieldDisplay
  EMOJIS = { mine: '💣', mask: '🀫', kaboom: '💥', tada: '🎉', bye: '👋' }.freeze

  def initialize(&display_strategy)
    @display_strategy = display_strategy
    # Uses puts to display by default
    @display_strategy = proc { |str| puts(str) } if display_strategy.nil?
  end

  def display(minefield)
    @display_strategy.call('  ' + (0...minefield.length).to_a.join(' '))

    minefield.field.each_with_index{|line, x|
      @display_strategy.call(x.to_s + ' ' + line.each_with_index.map{|mined, y|
        if minefield.mask[x][y]
          EMOJIS[:mask]
        elsif mined
          EMOJIS[:mine]
        else
          MineFieldHinter.hint(minefield, x, y)
        end
      }.join(' '))
    }
  end

  def say(something)
    @display_strategy.call something
  end

  def explode
    @display_strategy.call EMOJIS[:kaboom]
  end

  def congratulate
    @display_strategy.call EMOJIS[:tada]
  end

  def wave_bye
    @display_strategy.call EMOJIS[:bye]
  end
end
