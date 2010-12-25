class HelloWorld
  Version = "1.0"
  attr_accessor :name
  def initialize(myname="Ruby")
    @name = myname
  end
# ここはアクセッサメソッドなので
#   def name
#     return @name
#   end
#   def name=(value)
#     return @name
#   end
  def hello
    print "Hello,world I am " , @name , "\n"
  end
end

bob = HelloWorld.new("Bob")
alice = HelloWorld("Alice")
ruby = HelloWorld.new

bob.hello

