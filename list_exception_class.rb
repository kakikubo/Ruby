# よく使うExceptionをまとめてprintします。
ObjectSpace.each_object(Class) do |x|
  puts x if x.ancestors.member? Exception
end
