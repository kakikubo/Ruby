class Vector
  attr_reader :x, :y
  def initialize(x=0 , y=0)
    @x, @y = x, y
  end
  def inspect
    "(#{@x}, #{@y})"
  end
  def +(other)
    Vector.new(@x + other.x, @y + other.y)
  end
  def -(other)
    Vector.new(@x - other.x, @y - other.y)
  end
  def +@
    self.dup
  end
  def -@
    Vector.new(-@x,-@y)
  end
  def ~@
    Vector.new(-@y,@x) #90度反転させた座標を返す
  end

  def [](idx)
    case idx
    when 0
      @x
    when 1
      @y
    else
      raise ArgumentError,"out of range `#{idx}'"
    end
  end

  def []=(idx,val)
    case idx
    when 0
      @x = val
    when 1
      @y = val
    else
      raise ArgumentError,"out of range `#{idx}'"
    end
  end
end

vec0 = Vector.new(3,6)
vec1 = Vector.new(1,8)

p vec0
p vec1
p vec0 + vec1
p vec0 - vec1
p "====="
p vec0[0]
p vec0[1] = 2
p vec0[1]
p vec0[2]
