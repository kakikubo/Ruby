require 'find'

IGNORES = [ /^\./, /^CVS$/, /^RCS$/ , /^\.svn$/]

def listdir(top)
  #ここで指定するtopは絶対パスである必要がある
  Find.find(top){ |path|
    if FileTest.directory?(path)
      dir, base = File.split(path)
      IGNORES.each{ |re|
        if re =~ base
          Find.prune
        end
      }

      puts path
    end
  }
end

listdir(ARGV[0])
