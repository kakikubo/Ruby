file = ARGV[0]
begin
  io = open(file)
rescue
  sleep 10
  retry
end

data = io.read
print data
io.close


