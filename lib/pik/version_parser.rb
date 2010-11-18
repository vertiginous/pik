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
      @interpreter ||= @parts[0]
    end
    
    def version
      md = @parts[1].match(/\d\.\d\.\d\.\d|\d\.\d\.\d/)
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
      match(/patchlevel (\d+)|\dp(\d+)/) if interpreter == 'ruby'
    end

    def dev
      match(/(dev)/) if interpreter == 'ruby'
    end
    
    def full_version
      @version
    end

    def short_version
      pl = "-p#{patchlevel}" if patchlevel
      pl = "-#{dev}" if dev
      diff = "-#{differentiator}" if differentiator
      "#{interpreter.downcase}-#{version}#{pl}#{diff}"
    end
    
    def differentiator
      match(/.+\-(.+): .+/)
    end

    def match(re)
      md = @version.match(re) 
      md.captures.compact[-1] if md
    end

  end
  
end
      
        

  