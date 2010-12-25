pattern = Regexp.new(ARGV[0])
file = open(ARGV[1])
max_matches = 10
matches = 0
while text = file.gets
  if matches >= max_matches
    break
  end
  if pattern =~ text
    matches += 1
    print text
  end
end

print "end\n"
file.close
