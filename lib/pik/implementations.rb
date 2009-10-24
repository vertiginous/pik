require 'open-uri'

module Pik
  
  module Implementations
    
    def self.[](implementation)
      self.send(implementation.downcase)
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
      raise "Pik isn't aware of an implementation called '#{meth}' for Windows."
    end
  
    def self.list
      h = {}
      [ruby, jruby, ironruby].each{|i| h[i.subclass] = i.versions  }
      h
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
          versions.select{|v,k| v =~ pattern }.max
        end
      end
          
      def most_recent(vers=versions)
        vers.max
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