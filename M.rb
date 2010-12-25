module M
  def meth
    puts "meth"
  end
end

class C
  include M
end

c = C.new
c.meth
