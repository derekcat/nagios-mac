#!/usr/bin/ruby
#this is a script for checking free ram left
#the script should be used as follows: check_memory.rb <lowest percent for warning> <lowest percent for critical>
#Example check_memory.rb 25 15
# this would warn you when 25% of the memory is not free and would be critical when 25% of it is not free
#min and max are not required
#some scripts may not having a warning and may have other stuff
MEGABYTE = 1024.0 * 1024.0
def bytes_to_megabytes bytes
  bytes /  MEGABYTE
end

exit_code = 0
status = "OK"
output_text = ""
using_performance_data = true
performance_data = ""
perf_label = "cpuload"
value = 0
uom = ""
warning = ARGV[0]
critical = ARGV[1]
min = 0
max = 100

#top -l 1| awk '/CPU usage/ {print $3, $5}'
user_cpu = `top -l 1| awk '/CPU usage/ {print $3}'`
user_cpu = user_cpu[0,(user_cpu.length-2)].to_f
system_cpu = `top -l 1| awk '/CPU usage/ {print $5}'`
system_cpu = system_cpu[0,(system_cpu.length-2)].to_f
total_cpu = system_cpu+user_cpu



#check for the max and such

if total_cpu > warning.to_f
  exit_code = 1
  status = "WARNING"
  if total_cpu > critical.to_f
    exit_code = 2
    status = "CRITICAL"
  end
end
  
#testing percents
if using_performance_data
  #setup the performance data
  value = total_cpu.to_i
  uom="%"
 performance_data= "#{perf_label}=#{value}#{uom};#{warning};#{critical};#{min};#{max}"
end
output_text = "#{status} CPU: #{total_cpu}% User:#{user_cpu}% Sytem: #{system_cpu}%"

puts output_text + " | "+performance_data
exit exit_code


