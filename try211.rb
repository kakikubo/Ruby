#q1
#例1
ary = []
100.times{ |i| ary[i] = i + 1 }
#例2
a = (1..100).to_a

#q2
a.collect{ |i| i * 100}
a.collect!{ |i| i * 100}

#q3
ary = (1..100).to_a
ary2 = ary.select{ |i| i % 3 == 0 }
ary.reject!{ |i| i % 3 != 0 }


#q4
ary = (1..100).to_a
ary2 = ary.reverse
p ary2

ary2 = ary.sort{ |a,b | -(a <=> b)}
p ary2

ary2 = ary.sort_by{ |i| -i }
p ary2

#q5
ary = (1..100).to_a
result = 0
ary.each{ |i|
result += i
}

p ary.inject(0){ |memo, i | memo += i }

#q6
ary = (1..100).to_a
ary2 = ary.sort_by{ |i| rand }
p ary2

#q7
ary = (1..100).to_a
result = Array.new
10.times{ |i|
  result << ary[i*10,10]
}

#q8
def sum_array(ary1,ary2)
  result = Array.new
  ary1.zip(ary2){ |a,b| result << a + b}
  return result
end

#q9
def balanced?(array)
  stack = Array.new()
  array.each{ |elem|
    case elem
    when '('
      stack.push(elem)
    when '{'
      stack.push(elem)
    when ')'
      prev_elem = stack.pop
      if prev_elem != '('
        return false
      end
    when '}'
      prev_elem = stack.pop
      if prev_elem != '{'
        return false
      end
    else
      return false
    end

  }
  if stack.empty?
    return true
  else
    return false
  end
end

