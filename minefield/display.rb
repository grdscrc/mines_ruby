# encoding: UTF-8

require File.join(File.dirname(__FILE__), 'hinter')

class Display
  EMOJIS = { mine: '💣', mask: '🀫', kaboom: '💥', tada: '🎉', bye: '👋' }.freeze

  def initialize(minefield)
    @minefield = minefield
    @hintfield = Hinter.new(@minefield)
  end

  def refresh
    puts('  ' + (0...@minefield.length).to_a.join(' '))

    @minefield.field.each_with_index{|line, x|
      puts(x.to_s + ' ' + line.each_with_index.map{|mined, y|
        if @minefield.mask[x][y]
          EMOJIS[:mask]
        elsif mined
          EMOJIS[:mine]
        else
          @hintfield.hint(x, y)
        end
      }.join(' '))
    }
  end

  def warn_error
    puts 'Invalid move ; syntax is <x> <y>'
  end

  def explode
    puts EMOJIS[:kaboom]
  end

  def congratulate
    puts EMOJIS[:tada]
  end

  def wave_bye
    puts EMOJIS[:bye]
  end
end
