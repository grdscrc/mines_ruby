require File.join(File.dirname(__FILE__), 'hinter')

# Uses puts to display
class MineFieldDisplay
  def self.display(minefield)
    puts '  ' + (0...minefield.length).to_a.join(' ')
    minefield.field.each_with_index{|line, x|
      puts x.to_s + ' ' + line.each_with_index.map{|mined, y|
        if minefield.mask[x][y]
          '🀫'
        elsif mined
          '💣'
        else
          MineFieldHinter.hint(minefield, x, y)
        end
      }.join(' ')
    }
  end

  def self.say(something)
    puts something
  end
end
