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
      match(/\[(.+)\]|(\.NET.+)/) 
    end
    
    def patchlevel
      match(/patchlevel (\d+)|\dp(\d+)/) 
    end
    
    def full_version
      match(/.+: (.+)/)
    end
    
    def match(re)
      md = @version.match(re) 
      md.captures.compact[-1] if md
    end
    
  end
  
end
      
        

  