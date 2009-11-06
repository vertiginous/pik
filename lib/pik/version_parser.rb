module Pik

  class VersionParser
  
    def self.parse(version)
      new(version)
    end
    
    def initialize(version)
      @version = version
      @parts = @version.split(/ |\(|\)/).reject{|i| i.empty? }
    end
    
    def interpreter
      @interpreter ||= @parts[1]
    end
    
    def version
      md = @parts[2].match(/\d\.\d\.\d\.\d|\d\.\d\.\d/)
      md[0] if md
    end
    
    def date
      case interpreter
      when 'IronRuby'
        nil
      when 'ruby', 'jruby'
        md = @version.match(/\d\d\d\d\-\d\d\-\d\d/)
        md[0] if md
      end
    end
    
    def platform
      md = @version.match(/\[(.+)\]|(\.NET.+)/) 
      md.to_a.compact.last if md
    end
    
    def patchlevel
      md = @version.match(/patchlevel (\d+)|\dp(\d+)/) 
      md.to_a.compact.last if md
    end
    
    def full_version
      @version[5..-1]
    end
    
  end
  
end
      
        

  