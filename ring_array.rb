class RingArray < Array
  def [](i)
    idx = i % size
    super(idx)
  end
end

eto = RingArray["子","丑","寅","卯","辰","巳",
               "午", "未","申","酉","戌","亥"]
p eto[6]
p eto[11]
p eto[15]
p eto[-1]
