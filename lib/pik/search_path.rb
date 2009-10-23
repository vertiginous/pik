
class SearchPath

  include Enumerable

	def initialize(path)
	  @path = path.to_s.split(';').reject{|i| i.empty? }
	end

	def remove(old_path)
    old = Pathname(old_path).expand_path.to_windows
    @path = @path.reject{|dir| Pathname(dir) == old }
    @path = @path.uniq
		self
	end

	def replace(old_path, new_path)
    old_path = Pathname(old_path)
    new_path = Pathname(new_path)
		@path.map!{|dir|
			if Pathname(dir) == old_path
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
    if old_path.nil?
      add(new_path)
      return self
    end
    old_path = Pathname(old_path)
    new_path = Pathname(new_path)
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
    Regexp.new(Regexp.escape(string.to_s), true)
  end
end
