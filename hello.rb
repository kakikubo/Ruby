
=begin
これがコメントになる。
らしいですよ。
=end
def hello
  print "Hello, Ruby\n"
end





name = ["小林" , "林","高野","森岡"]
print "最初の名前は " , name[0] ,"です\n"

if name[0] == "小林" then
  print(name[0] + "です\n")

end

name.each{|n|
  print(n,"です\n")
}

font_table = {"normal" => "+0" , "small" => "-1" , "big" => "+1"}

font_table.each{ |k,v|
  print(k,"と",v,"\n")
}


