require 'rubygems'
require 'ruby-wmi'

class WindowsEnv

	def self.system
		new('<SYSTEM>')
	end

	def self.user
		user = WMI::Win32_ComputerSystem.find(:first).username
		new(user)
	end

	def initialize(account)
		@env = WMI::Win32_Environment
		@memo = Hash.new{|h,k| h[k]= @env.find(:first, :conditions => {:name => k, :username => account} ) }
	end
	
	def [](name)
		@memo[name].variablevalue rescue nil
	end

	def []=(name, other)
		@memo[name].variablevalue = other
		@memo[name].put_
	end

	def to_hash
		r = {}
		vars = @env.find(:all, :conditions => {:username => @account})
		vars.each{|var|
			@memo[var.name] = var
			r[var.name] = var.variablevalue
		}
		r
	end

	def has_key?(key)
		!!self[key]
	end

end

# env = WindowsEnv.user
# home = env['home']
# p home

# env['home'] = env['home'] + '\desktop'

# p env['home'] 

# env['home'] = home
# p env['home']

# p env['path']

# p env.has_key?('path')
# p env.has_key?('rubyopt')

# p WindowsEnv.system.to_hash