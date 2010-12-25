#q1
def jparsedate(str)
  now = Time.now
  year = now.year
  month = now.month
  day = now.day
  hour = now.hour
  min = now.min
  sec = now.sec
  str.scan(/(午前|午後)?(\d+)(年|月|日|時|分|秒)/){
    case $3
      when "年"; year = $2.to_i
      when "月"; month = $2.to_i
      when "日"; day = $2.to_i
      when "時"; hour = $2.to_i
        hour += 12 if $1 == "午後"
      when "分"; min = $2.to_i
      when "秒"; sec = $2.to_i
    end
  }
  return Time.mktime(year,month,day,hour,min,sec)
end

p jparsedate("2006年12月23日午後8時17分50秒")

#q2
def ls_t(path)
  entries = Dir.entries(path)
  entries.reject!{ |name| /^\./ =~ name }

  mtimes = Hash.new
  entries = entries.sort_by{ |name|
    mtimes[name] = File.mtime(File.join(path,name))
  }

  entries.each{ |name|
    printf("%-40s %s\n", name , mtimes[name])
  }
  rescue => ex
    puts ex.message
end

ls_t(ARGV[0] || ".")

#q3
require "date"
module Calendar
  WEEK_TABLE = [
                [99,99,99,99,99,99,1,2,3,4,5,6,7],
                [2,3,4,5,6,7,8,9,10,11,12,13,14],
                [9,10,11,12,13,14,15,16,17,18,19,20,21],
                [16,17,18,19,20,21,22,23,24,25,26,27,28],
                [23,24,25,26,27,28,29,30,31,99,99,99,99],
                [30,31,99,99,99,99,99,99,99,99,99,99,99]
               ]
  module_function
  def cal(year, month)

    first = Date.new(year,month,1)
    end_of_month = ((first >> 1) - 1).day
    start = 6 - first.wday

    puts first.strftime("%B %Y").center(21) #FIXME centerってなんだ？
    puts " Su Mo Tu We Th Fr St" # ここが２１文字ある
    WEEK_TABLE.each{ |week|
      buf = ""
      week[start, 7].each{ |day|
      if day > end_of_month
        buf << "   "
      else
        buf << sprintf("%3d",day)
      end
      }
      puts buf
    }
  end
end

t = Date.today
Calendar.cal(t.year, t.month)
