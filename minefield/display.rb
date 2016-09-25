require File.join(File.dirname(__FILE__), 'hinter')

class MineFieldDisplay
  def self.display(minefield)
    minefield.field.each_with_index{|line, lindex|
      puts line.each_with_index.map{|mined, cindex|
        if minefield.mask[lindex][cindex]
          '🀫'
        elsif mined
          '💣'
        else
          MineFieldHinter.hint(minefield, lindex, cindex)
        end
      }.join ' '
    }
  end
end
