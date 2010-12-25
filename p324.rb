#q1
def print_libraries
  $:.each{ |file|
    next unless FileTest.directory?(file)
    Dir.open(file){ |dir|
      dir.each{ |name|
        if name =~ /\.rb$/i
          puts name
        end
      }
    }
  }
end

print_libraries
#q2
require "find"

def du(path)
  result = 0
  Find.find(path){ |f|
    if File.file?(f)
      result += File.size(f)
    end
  }
  printf("%d %s\n", result , path)
  return result
end
