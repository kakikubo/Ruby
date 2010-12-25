def foo
  open("/no/file")
end

def bar
  foo()
end

begin
  bar()
rescue => ex
  print ex.message, "\n"
end



