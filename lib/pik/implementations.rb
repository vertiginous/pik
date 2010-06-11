
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
    
    def self.devkit
      DevKit.new
    end
    
    def self.method_missing(meth)
      raise "Pik isn't aware of an implementation called '#{meth}' for Windows."
    end
  
    def self.list
      h = {}
      [ruby, jruby, ironruby, devkit].each{|i| h[i.subclass] = i.versions  }
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
        h = {}
        Hpricot(read).search("a") do |a|
          if a_href = a.attributes['href']
            href, link, version, rc = *a_href.match(@re)
            h["#{version}#{rc}"] =  @url + link  if version
          end
        end
        h
      end
  
      def read
        uri = URI.parse(@url+@path)
        uri.read rescue ''
      end    
  
      def subclass
        self.class.to_s.split('::').last
      end
      alias :name :subclass
      
      def after_install(install)
        puts
        p = Pik::Add.new([install.target + 'bin'], install.config)
        p.execute
        p.close
      end
  
    end
    
    class Ruby < Base
    
      # <a href="/frs/download.php/66874/ruby-1.9.1-p243-i386-mingw32-rc1.7z">
      # <a href="/frs/download.php/62269/ruby-1.9.1-p243-i386-mingw32.7z">
      def initialize
        super
        @path = "/frs/?group_id=167"
        @re   = /(.+ruby\-(.+)\-i386\-mingw32(.*)\.7z)/
      end
    
    end
    
    class IronRuby < Base
    
      def initialize
        super
        @path = "/frs/?group_id=4359"
        @re   = /(.+ironruby\-(.*)\.zip)/
      end
    
    end
    
    class JRuby < Base
    
      # <a href='http://jruby.kenai.com/downloads/1.4.0RC3/jruby-bin-1.4.0RC3.zip'>
      def initialize
        @url  = ''
        @path = "http://www.jruby.org/download"
        @re   = /(.+\-bin\-(.+)\.zip)/
      end

    end
    
    class DevKit < Base
    
      def initialize
        super
        @path = "/frs/?group_id=167"
        @re   = /(.+devkit-(.*)-.*\.7z)/
      end
      
      def after_install(install)
        devkit = install.target + 'devkit'
        p = Pik::Config.new(["devkit=#{devkit.to_windows}"], install.config)
        p.execute
        p.close

        p = Pik::Devkit.new(["update"], install.config)
        p.execute
        p.close
        puts
      end
        
    end  

  end
  
end