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
      @interpreter ||= @parts[0].downcase if @parts[0]
    end
    
    def version
      md = @parts[1].match(/\d\.\d\.\d/)
      md[0] if md
    end
    
    def date
      case interpreter
      when 'ironruby'
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
    
    def dev
      match(/\d(dev)/)
    end

    def patchlevel?
      patchlevel && interpreter == 'ruby'
    end

    def short_version
      return @short if @short
      @short =  "#{interpreter}-#{version}"
      @short << "-p#{patchlevel}" if patchlevel?
      @short << "-dev" if dev
      @short
    end

    def full_version
      @version
    end
    
    def match(re)
      md = @version.match(re) 
      md.captures.compact[-1] if md
    end
    
  end
  
end
      
        

  