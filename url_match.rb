str = "http://www.ruby-lang.org/ja/"
%r|http://([^/]*)/| =~ str
print "server address: ", $1, "\n"

str2 = "http://www.example.co.jp/foo/?name=bar#baz"
%r|^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?| =~ str2
print "scheme name   : ", $2, "\n"
print "server address: ", $4, "\n"
print "path          : ", $5, "\n"
print "query         : ", $7, "\n"
print "fragment      : ", $9, "\n"
print  $1 ,$2 ,$3 ,$4 ,$5,$6,$7,$8,$9, "\n"
