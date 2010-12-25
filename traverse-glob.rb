def traverse(path)
  Dir.glob("#{path}/**/*\0#{path}/**/.*").each{ |name|
    unless FileTest.directory?(name)
      process_file(name)
    end
  }
end
def process_file(path)
  puts path
end

traverse(ARGV[0])

