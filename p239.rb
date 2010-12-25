str  = "Ruby is an object oriented programming language "

ary = str.split
p ary

p ary.sort

p ary.sort_by{ |s| s.downcase}

cap_ary =  ary.collect{ |word| word.capitalize }
p cap_ary.join(" ")

result = Hash.new(0)
chars = str.split(//)
chars.each{ |c| result[c] += 1 }
result.keys.sort.each{ |c|
  puts "'#{c}': #{"*" * result[c]}"
}

def kan2num(string)
  digit4 = digit3 = digit2 = digit1 = "0"

  nstring = string.dup
  nstring.gsub!(/一/,"1")
  nstring.gsub!(/二/,"2")
  nstring.gsub!(/三/,"3")
  nstring.gsub!(/四/,"4")
  nstring.gsub!(/五/,"5")
  nstring.gsub!(/六/,"6")
  nstring.gsub!(/七/,"7")
  nstring.gsub!(/八/,"8")
  nstring.gsub!(/九/,"9")

  if nstring =~ /((\d)?千)?((\d)?百)?((\d)?十)?(\d)?$/
    if $1
      digit4 = $2 || "1"
    end
    if $3
      digit3 = $4 || "1"
    end
    if $5
      digit2 = $6 || "1"
    end
    digit1 = $7 || "0"
  end

  return (digit4+digit3+digit2+digit1).to_i

end

p kan2num("七千八百二十三")

def num2asterisk(str)
  num = ""
  str.split(//).each{ |char|
    char.sub!("0","")
    char.sub!("1","*")
    char.sub!("2","**")
    char.sub!("3","***")
    char.sub!("4","****")
    char.sub!("5","*****")
    char.sub!("6","******")
    char.sub!("7","*******")
    char.sub!("8","********")
    char.sub!("9","*********")
    num = num + num + num + num + num + num + num + num + num + num + char
  }
  return num
end


p num2asterisk("35")
length = num2asterisk("35").length
p length
