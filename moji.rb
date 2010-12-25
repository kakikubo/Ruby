moji = "文字列"
str1 = "これも#{moji}"
str2 = "これも文字列"

p str1
p str2

desc = %Q{Rubyの文字列には「''」も「""」も使われます}
str = %q|Ruby said, 'Hello World'|
p desc
p str

10.times{ |i|
  10.times{ |j|
  print <<-"EOB"
i: #{i}
j: #{j}
i * j = #{i*j}
  EOB
  }

}

str = "Ruby In A Nutshell:Yukihiro Matsumoto:2001:USA"
column = str.split(/:/)
p column

str = "あいうえお"
p str[2].chr
p str.split(//u)[2]
p str[2,4]
