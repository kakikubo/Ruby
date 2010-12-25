#q1
def wc(file)
  nline = nword = nchar = 0
  File.open(file){ |io|
    io.each{ |line|
      words = line.split(/\s+/).reject{ |w| w.empty? }
      nline += 1
      nword += words.length
      nchar += line.length
    }
  }
  puts "lines=#{nline} words=#{nword} chars=#{nchar}"
end

wc(__FILE__)

#q2 FIXME
def tee(input, *outputs)
  input.each{ |line|
    outputs.each{ |io| io.write(line)}
  }
end

filename = ARGV.shift
open(filename,"r+"){ |io|
  tee(io,$stdout, $stderr)
}

#q3
def tail(lines,file)
  queue = Array.new
  open(file){ |io|
    while line = io.gets
      queue.push(line)
      if queue.size > lines
        queue.shift
      end
    end
  }
  queue.each{ |line| print line}
end


puts "==="
tail(10,__FILE__)
puts "==="
tail(3,__FILE__)
