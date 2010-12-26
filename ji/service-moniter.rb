#! /usr/bin/env ruby
require 'net/http'
require 'net/smtp'
require 'rubygems'
require 'date'
require 'timeout'
require 'pty'
require 'expect'
require 'optparse'
require 'thread'
require 'yaml'

MONITORVERSION="0.4"
TIMEOUT="10"
@dbcheck = false
@forcerestart = false
@statusfile = "/tmp/rebootstatus"
@execmode = ""
SMTP_HOST="localhost"
TARGET_HOST="localhost"

from_addr = 'kakikubo@gmail.com'
to_addr =  ['kakikubo@gmail.com']
now = DateTime.now.hour

def define_prog(progname)
  prog  = `which #{progname}`
  prog.chomp!
end

@ruby = define_prog("ruby")
@mongrel = define_prog("mongrel_rails")


OptionParser.new do |opt|
  opt.on('-d','enable dbcheck') {
    @dbcheck = true
  }
  opt.banner = "Usage: #{File.basename($0)} [options] mongrel.yml"
  opt.on("-v","--version", String, "Print Version"){|v|
    puts "#{File.basename($0)} Version #{MONITORVERSION}"
    exit 0
  }
  opt.on("-c","--config=MONGRELYML", String, "Specify the MONGRELYML file"){|c|
    @mongrel_yml = c
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
    raise OptionParser::ParseError, "Config File was not specified" unless @mongrel_yml
  rescue OptionParser::ParseError => err
    $stderr.puts err.message
    $stderr.puts opt.help
    exit 1
  end
end

def parse_mongrel_yml(ymlfile)
  @server_array = []
  config = YAML.load_file(ymlfile)
  arrays = config["servers"]
  arrays.times do |i|
    ar = {}
    ar['user'] = config["user"]
    ar['group'] = config["group"]
    ar['port']  = config["port"].to_i + i
    ar['cwd']   = config["cwd"]
    ar['environment'] = config["environment"]
    ar['log_file'] = config["log_file"]
    ar['pid_file'] = config["pid_file"]
    ar['docroot'] = config["docroot"]
    ar['address'] = config["address"]
    ar['host'] = TARGET_HOST
    @server_array << ar
  end
  return @server_array
end


# ruby script/generate contoroller Monitor index
@mail_flg = nil
@messages = []
@process_host = []
@appname = File.basename @mongrel_yml, ".yml"

TARGET_SERVICE = parse_mongrel_yml(@mongrel_yml)
class DatabaseError < StandardError ; end

def absolute_path(filepath,cwd)
  unless filepath =~  /^\//
    filepath = cwd + "/" + filepath
  else
    filepath
  end
end

def restart_mongrel(t)
  # host,port,user,appdir,tmpdir,logdir = t[0],t[1],t[2],t[3],t[4],t[5]
  puts "restart mongrel #{t['host']}:#{t['port']}"  if $DEBUG
  addr  = t['address']
  cwd   = t['cwd']
  droot = t['docroot']
  env   = t['environment']
  group = t['group']
  host  = t['host']
  log   = t['log_file']
  pid   = t['pid_file']
  port  = t['port'].to_s
  user  = t['user']

  pid = absolute_path(pid,cwd)
  log = absolute_path(log,cwd)
  piddir  = File.dirname pid
  pidfile = piddir + '/' + @appname + '.' + port + '.pid'
  logdir  = File.dirname log
  logfile = logdir + '/' + @appname + '.' + port + '.log'

  cmd = [
         "if [ -f #{pidfile} ]; then /bin/kill -INT  `cat #{pidfile}` ; /bin/rm #{pidfile}; fi ",
         "#{@ruby} #{@mongrel} start -d -e #{env} -c #{cwd} --user #{user} --group #{group} -p #{port} -P #{pidfile} -l #{logfile} "
        ]
  puts cmd[0] if $DEBUG
  puts cmd[1] if $DEBUG

  system cmd[0]
  system cmd[1]

end

def service_check(target)

  puts "#{target['host']}:#{target['port']})" if $DEBUG
  cnt = 0
  begin
    cnt += 1
    timeout(10){
      client = Net::HTTP.start(target['host'],target['port'])
      result = client.get("/monitor").body
      result.chomp!
      if @forcerestart == true
        return false
      elsif @dbcheck == false
        @messages << "#{target['host']}:#{target['port']} ok\n"
        return true
      elsif  result == "A00000001"
        @messages << "#{target['host']}:#{target['port']} ok\n"
        return true
      else
        puts "error" if $DEBUG
        raise DatabaseError,"Database Error occurred"
      end
    }
  rescue Timeout::Error => ex
    sleep 1
    retry unless cnt > 2
    return false
  rescue Errno::ECONNREFUSED => ex
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

def send_mail(from, to, message)
  # using SMTP#finish
  Net::SMTP.start( SMTP_HOST, 25 ){ |smtp|
    smtp.ready(from, to){ |f|
      f.puts "From: #{from}"
      f.print "To:" + to.join(",") + "\n"
      f.puts "Subject: mongrel service check alert mail"
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
    @messages << "#{t["host"]}:#{t["port"]} restarted mongrel\n"
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
  to_addr.delete_if{ |x| x =~ /(.*)gmail.com$/ } if @forcerestart
  send_mail(from_addr, to_addr, @messages.to_s)
end
puts @messages.to_s if $DEBUG

