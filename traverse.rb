def traverse(path)
  if FileTest.directory?(path)
    dir = Dir.open(path)
    while name = dir.read
      next if name == "."
      next if name == ".."
      traverse(path + "/" + name)
    end
    dir.close
  else
    process_file(path)
  end
end

def process_file(path)
  puts path
end

traverse(ARGV[0])
