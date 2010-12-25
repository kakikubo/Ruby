#!/usr/bin/env ruby
# divide.rb (割り算)
=begin
FIXME
正直いって、yieldが理解できていない為、まだ以下のコードはどうやって
使えばいいのか分からない(泣)
=end

def debug(if_level)
  yield if ($DEBUG == true) || ($DEBUG && $DEBUG >= if_level)
end

def pdebug(str,if_level=1)
  debug(if_level){ $stderr.puts('DEBUG: ' + str)}
end
numerator = rand(100)  # 分子
denominator = rand(10) # 分母
pdebug "Dividing #{numerator} by #{denominator}" , 3
puts numerator / denominator
