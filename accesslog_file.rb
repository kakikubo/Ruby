# 日ごとのアクセス数を調べる・アクセス数の出力
#FIXME
MONTH = {'jan' => 1, 'feb' => 2, 'mar' => 3, 'apr' => 4,
         'may' => 5, 'jun' => 6, 'jul' => 7, 'aug' => 8,
         'sep' => 9, 'oct' =>10, 'nov' =>11, 'dec' =>12}

pattern = ARGV.shift
count = Hash.new(0)

while line = gets()
  column = line.chomp.split
  path = column[6]
  #next if path !~ pattern  #ここは書籍とおりにするとエラーになる。
=begin
上記のエラー内容は以下の通り。
Kacintosh% ruby  accesslog_file.rb  /  /opt/local/apache2/logs/access_log
accesslog_file.rb:13:in `=~': type mismatch: String given (TypeError)
        From accesslog_file.rb:13

なんで…?
=end
 next if path != "#{pattern}"
=begin
  これなら大丈夫。正規表現なのがそもそも間違い?
  いや、でもパターンを引数に取るのだからいいわけか。
  じゃあ、正規表現で本当にパターンマッチさせるなら…？
  next if path !~ /#{pattern}/
  こうなるね。なんだ。これだけか。
=end
  datetime = column[3]
  if %r|\[(\d+)/(\w+)/(\d+)| =~ datetime
    day, month, year = $1, MONTH[$2.downcase], $3
    count["#{year}/#{month}/#{day}"] += 1
  end
end

count.sort{ |a,b| a[0] <=> b[0] }.each{ |key,value|
  print key, ":", value, "\n"
}
