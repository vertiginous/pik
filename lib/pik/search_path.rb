
class SearchPath

  include Enumerable

	def initialize(path)
	  @path = path.to_s.split(';').reject{|i| i.empty? }
	end

	def remove(old_path)
    old = Pathname(old_path).expand_path.to_windows
    @path = @path.reject{|dir| dir.downcase == old.to_s.downcase }
    @path = @path.uniq
		self
	end

	def replace(old_path, new_path)
    old_path = Pathname(old_path)
    new_path = Pathname(new_path)
		@path.map!{|dir|
			if dir.downcase == old_path.expand_path.to_windows.to_s.downcase
 				new_path.to_windows.to_s
			else
 				dir 
			end
		}
    @path = @path.uniq.compact
		self
	end
  
  def each
    @path.each{|path| yield path }
  end

	def add(new_path)
    new_path = Pathname(new_path)
		@path << new_path.to_windows.to_s
		self
	end

	def replace_or_add(old_path, new_path)
    old_path = Pathname(old_path)
    new_path = Pathname(new_path)
	  return self if old_path.to_windows == new_path.to_windows
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
    Regexp.new(Regexp.escape(string.to_s), true)
  end
end
