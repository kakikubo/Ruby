file = open(ARGV[0])
while text = file.gets
  next if /^\s*$/ =~ text
  next if /^#/ =~ text
  print text
end
