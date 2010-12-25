t0 = Time.now
open("/Users/kakikubo/Desktop/ken_all.csv").each{ |line|
  line.chomp!
  line.split(",")
}
p Time.now - t0
