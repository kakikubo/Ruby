week = Hash.new
week.store("sunday"    , "日曜日")
week.store("monday"    , "月曜日")
week.store("tuesday"   , "火曜日")
week.store("wednesday" , "水曜日")
week.store("thursday"  , "木曜日")
week.store("friday"    , "金曜日")
week.store("saturday"  , "土曜日")

p week
p week.size

%w(sunday monday tuesday wednesday thursday  friday saturday).each{ |key|
  puts "「#{key}」 は　#{week[key]}の事です"
}

def str2hash(str)
  hash = Hash.new()
  array = str.split(/\s+/)
  while key = array.shift
    value = array.shift
    hash[key] = value
  end
  return hash
end

p str2hash("blue 青 white 白 red 赤")

class OrderedHash
  def initialize()
    @keys = Array.new()
    @content = Hash.new()
  end

  def [](key)
    @content[key]
  end

  def []=(key, value)
    @content[key] = value
    if !@keys.include?(key)
      @keys << key
    end
  end

  def delete(key)
    @keys.delete(key)
    @content.delete(key)
  end

  def keys()
    @keys.each{ |key|
      @content[key]
    }
  end

  def each()
    @keys.each{ |key|
      yield(key, @content[key])
    }
  end
end

oh = OrderedHash.new()
oh["one"] = 1
oh["two"] = 2
oh["three"] = 3
oh["two"] = 4
p oh.keys()
oh.each{ |key,value|
p [key, value]
}



