def cels2fahr(cels)
  return Float(cels) * 9 / 5 + 32
end

def fahr2cels(fahr)
  return (Float(fahr) - 32 ) * 5 / 9
end

1.upto(100){ |i|
  f = cels2fahr(i)
  print "摂氏",i,"華氏",f,"\n"

}

def dice
  rand(6) + 1
end

def prime?(num)
  # 2より小さい数は素数ではない
  return false if num < 2
  2.upto(Math.sqrt(num)){ |i|
    #print i,"\n"
    if num % i == 0
      return false
    end
  }
  return true
end
