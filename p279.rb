#q1
addr = "kakikubo@gmail.com"
%r|([^/#?]+)@(.*)| =~ addr
print "$1 = ",$1,"\n"
print "$2 = ",$2,"\n"


#q2
str1 = "オブジェクト指向は難しい! なんて難しいんだ!"
str1.sub!(/難しい/,'簡単だ')
p str1.sub!(/難しいんだ/,'簡単なんだ')

#q3
def word_capitalize(str)
  return str.split(/\-/).collect{ |w| w.capitalize}.join('-')
end

p word_capitalize("in-reply-to") #=> "In-Reply-To"
p word_capitalize("X-MAILER")    #=> "X-Mailer"

