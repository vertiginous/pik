require 'open-uri'

module Pik
  
  module Implementations
    
    def self.[](implementation)
      self.send(implementation)
    end
  
    def self.ruby
      Ruby.new
    end
    
    def self.ironruby
      IronRuby.new
    end
    
    def self.jruby
      JRuby.new
    end
    
    def self.method_missing(meth)
      raise "The implementation '#{meth}' wasn't found"
    end
  
    def self.list
      h = {}
      self.each{|i| h[i.subclass] = i.versions  }
      h
    end
  
    def self.each
      [ruby, jruby, ironruby].each{|i| yield i }
    end 
    
    class Base
    
      def self.find(*args)
        new.find(*args)
      end
    
      def initialize
        @url = 'http://rubyforge.org'
      end
      
      def find(*args)
        if args.empty?
          return most_recent
        else
          pattern = Regexp.new(Regexp.escape(args.first))
          versions.find{|v,k| v =~ pattern }
        end
      end
          
      def most_recent(vers=versions)
        vers.sort.last
      end
      
      def versions
        vers = read.scan(@re).map{|v| v.reverse}
        vers.map!{ |name, path| [name, @url + path] }.flatten!
        Hash[*vers]
      end
  
      def read
        uri = URI.parse(@url+@path)
        uri.read
      end    
  
      def subclass
        self.class.to_s.split('::').last
      end
  
    end
    
    class Ruby < Base
    
      def initialize
        super
        @path = "/frs/?group_id=167"
        @re  = /\"(.+ruby\-(.+)\.7z)\"/
      end
    
    end
    
    class IronRuby < Base
    
      def initialize
        super
        @path = "/frs/?group_id=4359"
        @re  = /\"(.+ironruby\-(\d\.\d\.\d)\.zip)\"/
      end
    
    end
    
    class JRuby < Base
    
      def initialize
        @url  = ''
        @path = "http://www.jruby.org/download"
        @re   = /\<p.*\>\<a .*href\=\"(.+ruby-bin\-(.+)\.zip)\"/
      end
    end
  
  end
  
end