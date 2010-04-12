#!/usr/bin/ruby
#this is a base template for creating nagios plugins
#the file should be excuted using the following: basic_check.rb <warning> <critical> <min> <max>
#min and max are not required
#some scripts may not having a warning and may have other stuff

exit_code = 0
output_text = "Ok"
using_performance_data = true
performance_data = ""
perf_label = ""
value = 0
uom = ""
warning = ARGV[0]
critical = ARGV[1]
min = ARGV[2]
max = ARGV[3]

if using_performance_data
  performance_data= "#{perf_label}=#{value}#{uom};#{warning};#{critical};#{min};#{max}"
end

puts output_text + " | "+performance_data
exit exit_code