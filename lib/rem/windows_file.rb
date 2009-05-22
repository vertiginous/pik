
class WindowsFile < File

	def self.join(*items)
		super.gsub('/','\\')
	end

	def self.to_ruby
		super.gsub('\\','/')
	end

end

