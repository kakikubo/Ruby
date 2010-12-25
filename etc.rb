require 'etc'
include Etc

st = File.stat("/usr/bin/ruby")
pw = getpwuid(st.uid)
p pw.name
gr = getgrgid(st.gid)
p gr.name
