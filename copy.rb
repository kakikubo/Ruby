def copy(from,to)
  open(from){ |input|
    open(to,"w"){ |output|
      output.write(input.read)
    }
  }
end

copy(ARGV[0],ARGV[1])
