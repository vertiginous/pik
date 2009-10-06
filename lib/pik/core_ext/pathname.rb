
class Pathname

  def to_windows
    @path.gsub!('/','\\')
    self
  end
  
  def to_ruby
    @path.gsub!('\\','/')
    self
  end
  
  def ==(other)
    self_ = self.dup.to_ruby.to_s.downcase
    other = other.dup.to_ruby.to_s.downcase
    self_ == other
  end
  
end
