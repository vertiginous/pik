
class Pathname

  def to_windows
    @path.dup.gsub('/','\\')
  end

end

