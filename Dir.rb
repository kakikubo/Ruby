Dir.open("/usr/bin"){ |dir|
  dir.each{ |name|
    p name
  }
}
