require "open-uri"

# HTTP経由でデータを読み込む
open("http://www.ruby-lang.org"){ |io|
  puts io.read
}

# FTP経由でデータを読み込む
open("ftp://www.ruby-lang.org/pub/ruby/ruby-1.9.0-2.tar.gz"){ |io|
  open("ruby-1.9.0-2.tar.gz", "w"){ |f|
    f.write(io.read)
  }
}
