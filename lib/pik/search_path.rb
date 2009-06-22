
class SearchPath

	def initialize(path)
		@path = path.split(';')
	end

	def remove(old)
		@path = @path.map{|dir|
			case dir
			when regex(old)
				nil 
			else 
				dir 
			end
		}.uniq.compact
		self
	end

	def replace(old, new)
		@path = @path.map{|dir|
			case dir
			when regex(old)
				new 
			else 
				dir 
			end
		}.uniq.compact
		self
	end

	def add(new)
		@path << new
		self
	end

	def replace_or_add(old, new)
		old_path = @path.dup
		replace(old, new)
		add(new) if @path == old_path
		self
	end

	def join
		WindowsFile.join(@path.join(';'))
	end
	alias :to_s :join

  def regex(string)
    Regexp.new(Regexp.escape(string.gsub('/', "\\")), true)
  end
end
