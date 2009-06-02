require 'win32ole'

class WindowsEnv

	def self.system
		@system ||= new('SYSTEM', shell)
	end

	def self.user
		@user ||= new('User', shell)
	end

	def initialize(account, shell)
		@env = shell.environment(account)
	end

	def set(items)
		items.each{|k,v| self[k] = v }
	end
	
	def [](name)
		@env.item(name)
	end

	def []=(name, other)
		if other == nil
			@env.remove(name)
		else
			@env.setproperty('item', name, other)
		end
	end

	def has_key?(key)
		!!self[key]
	end

	private

	def self.shell
		@shell ||= WIN32OLE.new('WScript.Shell')
	end

end

# env = WindowsEnv.user

# home = env['home']
# p home

# env['home'] = nil

# p env['home'] 

# env['rubyopt'] = '-rubygems'

# env['home'] = home
# p env['home']

# p env['path']

# p env.has_key?('path')
# p env.has_key?('rubyopt')


