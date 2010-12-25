#! /usr/bin/env ruby
require 'pp'
require 'net/http'
require 'net/smtp'
require 'rubygems'
#require 'net/ssh'
require 'timeout'
require 'pty'
require 'expect'
require 'optparse'
require 'yaml'

MONITORVERSION="0.1"
@dbcheck = false
@forcerestart = false
@statusfile = "/tmp/rebootstatus"
@execmode = ""
now = DateTime.now.hour
@config_files = []

OptionParser.new do |opt|
  opt.on('-d','enable dbcheck') {
    @dbcheck = true
  }
  opt.banner = "Usage: #{File.basename($0)} [options] mongrel.yml"

  opt.on("-v","--version", String, "Print Version"){|v|
    puts "#{File.basename($0)} Version #{MONITORVERSION}"
    exit 0
  }
  opt.on("-r", "--restart [TIME]",Integer ,'restart time(oclock)') { |time|
    unless time
      puts opt
      exit
    end
    begin
      @rtime = time % 24
      @execmode = "restart"
    rescue
      puts opt
      exit
    end
  }
  opt.on_tail("-h", "--help", "Show this message"){
    puts opt.help
    exit
  }
  begin
    opt.parse!(ARGV)
    raise OptionParser::ParseError, "Config File was not specified" unless ARGV.length == 1
  rescue OptionParser::ParseError => err
    $stderr.puts err.message
    $stderr.puts opt.help
    exit 1
  end
end


# opt.on("-c","--configfile [FILE]", String, "specify mongrel cluster yml file"){|config|
#   config.length
#   begin
#     @config_files << config
#     puts @config_files if $DEBUG
#   rescue
#     puts opt
#     exit
#   end
# }

# ruby script/generate contoroller Monitor index
from_addr = 'test-from@testdomain'
to_addr   = ['kakikubo@gmail.com']

@mail_flg = nil
@messages = []
@process_host = []
# mongrelクラスターのymlファイルを配列に指定する。この処理でとりあえずは取り出せる。
@array = []
@config_files.each{ |y|
  config = YAML.load_file(y)
  servers = config["servers"]
  port    = config["port"].to_i
  servers.times{
    @array << config.dup # ここでそのまま配列を渡すと
    config["port"] = config["port"] + 1 # この行の変更がオブジェクトに対して行われてしまうので注意
  }
}

pp @array

exit 0
TARGET_SERVICE = [
                  ["192.168.1.158",8000,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.158",8001,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.158",8002,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.158",8003,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.158",8004,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.158",8005,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.158",8100,"i_test","/var/green/test","/tmp/pids/client","/var/log/mongrel/client"],
                  ["192.168.1.158",8101,"i_test","/var/green/test","/tmp/pids/client","/var/log/mongrel/client"],
                  ["192.168.1.158",8102,"i_test","/var/green/test","/tmp/pids/client","/var/log/mongrel/client"],
                  ["192.168.1.158",8200,"i_test","/var/green/test","/tmp/pids/test","/var/log/mongrel/test"],
                  ["192.168.1.158",8201,"i_test","/var/green/test","/tmp/pids/test","/var/log/mongrel/test"],
                  ["192.168.1.159",8000,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.159",8001,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.159",8002,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.159",8003,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.159",8004,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.159",8005,"i_test","/var/green/test","/tmp/pids/user","/var/log/mongrel/user"],
                  ["192.168.1.159",8100,"i_test","/var/green/test","/tmp/pids/client","/var/log/mongrel/client"],
                  ["192.168.1.159",8101,"i_test","/var/green/test","/tmp/pids/client","/var/log/mongrel/client"],
                  ["192.168.1.159",8102,"i_test","/var/green/test","/tmp/pids/client","/var/log/mongrel/client"],
                  ["192.168.1.159",8200,"i_test","/var/green/test","/tmp/pids/test","/var/log/mongrel/test"],
                  ["192.168.1.159",8201,"i_test","/var/green/test","/tmp/pids/test","/var/log/mongrel/test"]
                 ]

class DatabaseError < StandardError ; end

def restart_mongrel(t)
  host,port,user,appdir,tmpdir,logdir = t[0],t[1],t[2],t[3],t[4],t[5]
  puts "restart mongrel #{host}:#{port}"  if $DEBUG
  password = "ijkdFJew"
  yes = "yes"
  unless tmpdir =~ /^\//
    piddir = appdir + "/" + tmpdir
    pidfile = "#{piddir}/mongrel.#{port}.pid"
  else
    pidfile = "#{tmpdir}/mongrel.#{port}.pid"
  end
  cmd = ["ssh #{host} -l #{user}",
         "cd #{appdir}",
         "if [ -f #{pidfile} ]; then kill -USR2 `cat #{pidfile}` ; fi ",
         "if [ -f #{pidfile} ]; then kill -INT  `cat #{pidfile}` ; rm #{pidfile}; fi ",
         "/usr/local/bin/ruby /usr/local/bin/mongrel_rails start -d -e production -c #{appdir} --user #{user} --group #{user} -p #{port} -P #{pidfile} -l #{logdir}/mongrel.#{port}.log"
        ]
      prompt = [/(password:)/,
                /(Password:)/,
                /(\-bash\-3.1\$ )/,
               /(Are you sure you want to continue connecting \(yes\/no\)\? )/,
               /(closed.)/]
#                /(\[.+\s\~\])/,
  re = Regexp.union(*prompt)
  STDOUT.flush
  PTY.spawn(cmd[0]){ |r, w, @pid|
    $expect_verbose = true if $DEBUG
    w.sync=true
    w.flush()
    puts "#{__FILE__}: #{__LINE__} @pid is #{@pid}" if $DEBUG
    begin
      while true
        r.expect(re,3){ |match|
          break unless match
          if match[1]                 # input password
            p match[1] if $DEBUG
            w.puts password
            puts "debug1" if $DEBUG
          elsif match[2]              # input sudo password
            w.puts password
            puts "debug2 #{match[2]}" if $DEBUG
          elsif match[3]              # get error
            puts "debug3 #{match[3]}" if $DEBUG
#            if @forcerestart
#              w.puts cmd[2]
#            else
              w.puts cmd[3]
              w.puts cmd[4]
#            end
            puts "debug3 #{match[3]}" if $DEBUG
            #sleep 3
            w.puts "logout"
          elsif match[4]              # get error
            puts "debug4 #{match[4]}" if $DEBUG
            w.puts yes
          elsif match[5]
            return true
          end
        }
      end
    rescue Errno::EIO => ex
      @state ||= ex.message
    rescue => ex
      puts "DEBUG Error!" if $DEBUG
      @state = ex.message
    end
  }
end

def service_check(target)

  cnt = 0
  host,port = target[0],target[1]
  begin
    cnt += 1
    client = Net::HTTP.start(host,port)
    result = client.get("/monitor").body
    result.chomp!
    if @forcerestart == true
      return false
    elsif @dbcheck == false
      @messages << "#{host}:#{port} ok\n"
      return true
    elsif  result == "A00000001"
      @messages << "#{host}:#{port} ok\n"
      return true
    else
      puts "error" if $DEBUG
      raise DatabaseError,"Database Error occurred"
    end
  rescue Errno::ECONNREFUSED => ex
    # @messages << "#{host}:#{port} #{ex.message}\t\t"
    sleep 1
    retry unless cnt > 2
    return false
  rescue DatabaseError => ex
    @messages << "#{host}:#{port} #{ex.message}\n"
    @mail_flg = true
  rescue => ex
    print ex.message
  end
end

def get_command_result(host,command)
  password = "password"
  #user = "app"
  #user = "i_test"
  user = "test"
  @messages << "\n\nProcess Status on #{host}\n"
  begin
    Net::SSH.start(host, user, :password => password, :keys => '/home/test/.ssh/id_rsa.pub') do |ssh|
      @messages << ssh.exec!(command)
    end
  rescue => ex
    @messages << ex.message
  end
  @messages << "\n\n"
end

def send_mail(from, to, message)
  # using SMTP#finish
  to =
  Net::SMTP.start( 'localhost', 25 ){ |smtp|
    smtp.ready(from, to){ |f|
      f.puts "From: #{from}"
      f.print "To:" + to.join(",") + "\n"
      f.puts "Subject: service check alert mail for pc"
      f.puts
      f.puts "#{message}"
    }
  }
end

def read_status(file)
  f = File::open(file,"r")
  state = f.read
  f.close
  return state
end

def write_status(file, string = "finished")
  File::open(file,"w"){ |f|
    f.write(string)
  }
end

if @execmode == "restart"
  puts "execmode restart" if $DEBUG
  if @rtime == now
    puts "reboot time" if $DEBUG
    unless FileTest.exist?(@statusfile)
      write_status(@statusfile,"ready")
      @forcerestart = true
    end
  else
    puts "not reboot time yet" if $DEBUG
    begin
      FileUtils.remove(@statusfile) if FileTest.exist?(@statusfile)
    rescue => ex
      puts ex.message
    end
  end
end


TARGET_SERVICE.each do |t|
  unless service_check(t)
    restart_mongrel(t)
    @messages << "#{t[0]}:#{t[1]} restarted mongrel\n"
    @process_host << t[0]
    @mail_flg = true
  end
end

if FileTest.exist?(@statusfile)
  if read_status(@statusfile) == "ready"
    write_status(@statusfile)
  end
end

if @mail_flg
  @process_host.uniq.each do |host|
   get_command_result(host,'ps -ef | grep [r]uby')
  end
  to_addr.delete_if{ |x| x =~ /(.*)gmail.com$/ } if @forcerestart
  send_mail(from_addr, to_addr, @messages.to_s)
end
puts @messages.to_s if $DEBUG
