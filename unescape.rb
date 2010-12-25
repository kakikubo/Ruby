def unescape(str)
  return nil unless str
  ret = str.dup
  ret.gsub!(/&#(\d+);|&(\w+);/) do | m|
    num, name = $1, $2
    if num          then num.to_i.chr
    elsif name == "quot" then '"'
    elsif name == "amp"  then '&'
    elsif name == "lt"  then '<'
    elsif name == "gt"  then '>'
    else m
    end
  end
  ret
end
