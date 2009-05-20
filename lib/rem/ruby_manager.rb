require 'rbconfig'
require 'pp'

rubies = Hash.new{|h,k| h[k] = {} }

ruby_bins = Dir[File.join(Config::CONFIG['bindir'], '..', '..', '*', 'bin', 'ruby.exe')]
ruby_bins.each do |ruby_exe|
	puts BatchFile.new(ruby_exe)
	puts
	puts
end

# rubies.each{|ver,hash| puts ver
#   hash.each{|k,v| puts "#{k} = #{v}"}
# }
# puts 'rubyopt environment variable is set' if ENV['RUBYOPT']
