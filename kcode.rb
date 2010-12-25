require "nkf"
opt = nil
case $KCODE
when "UTF8" then opt = "-w"
when "SJIS" then opt = "-s"
when "EUC" then opt = "-e"
end

while line = gets
  line = NKF.nkf("#{opt} -xm0", line) if opt
  print line
end
