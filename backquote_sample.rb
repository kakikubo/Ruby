dirlist = `ls`
dirlist.each do |line|
  if line =~ /.rb$/i
    print line
  end
end
