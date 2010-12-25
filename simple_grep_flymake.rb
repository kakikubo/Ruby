pattern = Regexp.new(ARGV[0])

file = open(ARGV[1]) 
while text = file.gets do
  if pattern =~ text
    print text
  end
end
file.close
