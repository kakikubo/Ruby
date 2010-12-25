require "jzipcode"
#require "nkf"
require "iconv"

t0 = Time.new
code = ARGV[0] || "1000000"
if rows = JZipCode.find(code)
  rows.each{ |row|
    address = row[6] + row[7]
    unless /^\210\310\211\272\202\311/ =~ row[8]
      address << row[8]
    end
#    puts NKF.nkf("-u", address)
    puts Iconv.conv('UTF-8','Shift_JIS', address)

  }
end
p Time.now - t0
