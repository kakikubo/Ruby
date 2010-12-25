ltotal = 0 #行数の合計
wtotal = 0 #単語数の合計
ctotal = 0 #文字数の合計

ARGV.each{ |file|
  begin
    input = open(file)
    l = 0
    w = 0
    c = 0
    while line = input.gets
      l +=1
      c += line.size
      line.sub!(/^\s+/,"")
      ary = line.split(/\s+/)
      w += ary.size
    end
    input.close
    printf("%8d %8d %8d %s\n", l, w, c, file)
    ltotal += l
    wtotal += w
    ctotal += c
  rescue => ex
    print ex.message, "\n"
  end

}
printf("%8d %8d %8d %s\n",ltotal, wtotal, ctotal, "total")
