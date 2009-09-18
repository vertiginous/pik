
class Pathname

  def to_windows
    @path.gsub!('/','\\')
    self
  end
  
  def to_ruby
    @path.gsub!('\\','/')
    self
  end

end

