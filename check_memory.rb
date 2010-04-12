#!/usr/bin/ruby
#this is a script for checking free ram left
#the script should be used as follows: check_memory.rb <lowest percent for warning> <lowest percent for critical>
#Example check_memory.rb 25 15
# this would warn you when 25% of the memory is not free and would be critical when 25% of it is not free
#the file should be excuted using the following: basic_check.rb <warning> <critical> <min> <max>
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
perf_label = "free_ram"
value = 0
uom = ""
warning = ARGV[0]
critical = ARGV[1]
min = ARGV[2]
max = ARGV[3]


#lets first get the free memory
free_memory = `top -l 1 | awk '/PhysMem/ {print $10}'`
free_memory = free_memory[0,(free_memory.length-2)].to_i
inactive_memory = `top -l 1 | awk '/PhysMem/ {print $6}'`
inactive_memory = inactive_memory[0,(inactive_memory.length-2)].to_i
total_free_memory = free_memory+inactive_memory


#get the installed memory
total_memory = `sysctl -n hw.memsize | awk '{print $0}'` 
total_memory = bytes_to_megabytes(total_memory.to_i)


#check for the max and such
percent = (total_free_memory/total_memory) * 100
if percent < warning.to_i
  exit_code = 1
  status = "WARNING"
  if percent < critical.to_i
    exit_code = 2
    status = "CRITICAL"
  end
end
  
#testing percents
if using_performance_data
 
  #setup the performance data
  value = percent.to_i
  uom="%"
 performance_data= "#{perf_label}=#{value}#{uom};#{warning};#{critical};#{min};#{max}"
end
output_text = "#{status} Installed Memory: #{total_memory }MB Free memory = #{total_free_memory}MB #{percent.to_i}% free"

puts output_text + " | "+performance_data
exit exit_code


