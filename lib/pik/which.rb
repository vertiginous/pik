
module Which

  class Base

    class << self
      def find(search_path=ENV['PATH'])
        path = SearchPath.new(search_path)
        path = path.find{|dir| exist?(dir)}
        Pathname(path) rescue nil
      end
  
      def exist?(path)
        !!exe(path)
      end
      
      def exe(path=find)
        glob(path).first
      end
      alias :bat :exe
      
      def glob(path)
        return [] if path.nil?
        glob = "#{Pathname.new(path).to_ruby}/{#{executables.join(',')}}"
        Pathname.glob(glob)
      end
    end
  end

  class Ruby < Base
  
    def self.executables
      ['ruby.exe', 'ir.exe', 'jruby.exe', 'jruby.bat']
    end
  
  end
  
  class Gem  < Base

    def self.executables
      ['gem.bat', 'igem.bat']
    end  
  
  end
  
  class SevenZip < Base
    def self.executables
      ['7za.exe']
    end 
  end

end
