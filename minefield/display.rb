# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'hinter')

# Uses puts to display
class MineFieldDisplay
  EMOJIS = { mine: '💣', mask: '🀫', kaboom: '💥', tada: '🎉', bye: '👋' }

  def self.display(minefield)
    puts '  ' + (0...minefield.length).to_a.join(' ')
    minefield.field.each_with_index{|line, x|
      puts x.to_s + ' ' + line.each_with_index.map{|mined, y|
        if minefield.mask[x][y]
          EMOJIS[:mask]
        elsif mined
          EMOJIS[:mine]
        else
          MineFieldHinter.hint(minefield, x, y)
        end
      }.join(' ')
    }
  end

  def self.say(something)
    puts something
  end

  def self.explode
    puts EMOJIS[:kaboom]
  end

  def self.congratulate
    puts EMOJIS[:tada]
  end

  def self.wave_bye
    puts EMOJIS[:bye]
  end
end
