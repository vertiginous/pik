
class Pathname

  def to_s
    @path.tr('/','\\').sub(/^(.):/){|s| s.upcase }
  end
  alias to_windows to_s
  
  def to_ruby
    @path.tr('\\','/').sub(/^(.):/){|s| s.upcase }
  end

  def to_bash
    @path.tr('\\','/').sub(/^(.):/){|s| "/#{s[0,1].downcase}"}
  end
  
  def ruby
    Pathname(self.to_ruby)
  end
  
  def windows
    Pathname(self.to_s)
  end
  
  def ==(other)
    return false unless Pathname === other
    self_ = self.dup.to_ruby.downcase
    other = other.dup.to_ruby.downcase
    self_ == other
  end
  
end
