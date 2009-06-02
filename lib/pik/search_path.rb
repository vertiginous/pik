
class SearchPath

	def initialize(path)
		@path = path.split(';')
	end

	def replace(old, new)
		@path.map!{|dir| 
			case dir
			when old 
				new 
			else 
				dir 
			end
		}.uniq!
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
		@path.join(';')
	end
	alias :to_s :join

end
