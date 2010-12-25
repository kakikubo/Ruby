class HelloCount
  Version = "1.0"

  @@count = 0

  def HelloCount.count
    @@count
  end

  def initialize(myname="Ruby")
    @name = myname
  end
  def hello
    @@count += 1
    print "Hello,world I am " , @name , "\n"
  end
end

bob = HelloCount.new("Bob")
alice = HelloCount("Alice")
ruby = HelloCount.new

p HelloCount.count
bob.hello
alice.hello
ruby.hello
p HelloCount.count

