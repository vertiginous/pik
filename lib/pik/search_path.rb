
class SearchPath

	def initialize(path)
	  @path = path.to_s.split(';')
	end

	def remove(old_path)
    old = Pathname.new(old_path).to_windows
		@path.reject!{|dir| dir =~ regex(old) }
		self
	end

	def replace(old_path, new_path)
  
    old_path = Pathname.new(old_path)
    new_path = Pathname.new(new_path)
		@path.map!{|dir|
			case dir
			when regex(old_path.to_windows)
				new_path.to_windows
			else 
				dir 
			end
		}.uniq.compact
		self
	end

	def add(new_path)
    new_path = Pathname.new(new_path)
		@path << new_path.to_windows
		self
	end

	def replace_or_add(old_path, new_path)
	  return self if old_path == new_path
		old_search_path = @path.dup
		replace(old_path, new_path)
		add(new_path) if @path == old_search_path
		self
	end

	def join
		@path.join(';')
	end
	alias :to_s :join

  def regex(string)
    Regexp.new(Regexp.escape(string), true)
  end
end
