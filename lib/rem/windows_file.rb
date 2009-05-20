
class WindowsFile < File

	def self.join(*items)
		super.gsub('/','\\')
	end

end

