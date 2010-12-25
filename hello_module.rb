module HelloModule
  Version = "1.0"
  def hello(name)
    print "Hello, ", name , ".\n"
  end
  module_function :hello
end

p HelloModule::Version
HelloModule.hello("Alice")

include HelloModule
p Version
hello("Alice")
