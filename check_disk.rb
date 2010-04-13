#!/usr/bin/ruby
#this script checks for free disk space on a drive
#the command is ran as so
#check_disk.rb <warning> <critical> <diskname>
#example: check_disk.rb 10 5 disk0s2
#this would be a warning when there is only 10% free on disk0s2


exit_code = 0
status = "OK"
output_text = ""
using_performance_data = true
performance_data = ""
perf_label = "free_disk_space"
value = 0
uom = ""
warning = ARGV[0]
critical = ARGV[1]
disk = ARGV[2]

#df -l | grep 'disk0s2' | awk '{print $4"/"$2" free ("$5" used)"}'

size = `df -l | grep '#{disk}' | awk '{print $2}'`.to_f
free = `df -l | grep '#{disk}' | awk '{print $4}'`.to_f
percent = ((free/size) * 100)


#check for the max and such

if percent < warning.to_f
  exit_code = 1
  status = "WARNING"
  if percent < critical.to_f
    exit_code = 2
    status = "CRITICAL"
  end
end
  
#testing percents
if using_performance_data
  #setup the performance data
  value = percent.to_i
  uom="%"
 performance_data= "#{perf_label}=#{value}#{uom};#{warning};#{critical};"
end
free_gb =  `df -hl | grep '#{disk}' | awk '{print $4}'`.chomp.chop.chop
total_gb = `df -hl | grep '#{disk}' | awk '{print $2}'`.chomp.chop.chop
output_text = "#{status} Free: #{percent.to_i}% #{free_gb}GB/#{total_gb}GB"

puts output_text + " | "+performance_data
exit exit_code


