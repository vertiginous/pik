require 'optparse'

module Pik

  class QuitError < StandardError
  end

  class  Command
    
    attr_reader :config
    
    attr_reader :options
    
    attr_accessor :output
    
    def self.cmd_name
      name.split('::').last.downcase.to_sym
    end
    
    def self.description
      new.options.to_s
    end
    
    def self.inherited(subclass)
      Commands.add(subclass)
    end
    
    def self.it(str)
      @summary = str
    end
    
    def self.summary
      @summary 
    end
    
    def self.aka(*aliases)
      @names = names + aliases
    end
    
    def self.names
      @names ||= [cmd_name]
    end
  
    def self.clean_gem_batch
      BatchFile.open("#{$0}.bat") do |gem_bat|
        # remove old calls to .pik/pik batches
        gem_bat.remove_line( /call.+pik.+bat/i )
        gem_bat.write  
      end
    end

    def self.choose_from(patterns, config)
      if patterns.empty?
        possibles = config.keys  
      else
        possibles = patterns.map{|p| config.keys.grep(Regexp.new(Regexp.escape(p.to_s))) }
        possibles = possibles.inject{|m,v| m & v }.flatten.uniq
      end
      case possibles.size
      when 0
        hl.say 'Nothing matches:'
        return nil
      when 1
        return possibles.first
      else
        hl.say('Select which Ruby you want:')
        ver = hl.choose(*possibles)
        return ver
      end
    end
    
    def self.hl
      @hl ||= HighLine.new
    end
  
    def initialize(args=ARGV, config_=nil)
      @args    = args
      @options = OptionParser.new
      @config  = config_ || ConfigFile.new
      @hl      = HighLine.new
      add_sigint_handler
      options.program_name = "#{File.basename($0)} #{self.class.names.join('|')}"
      command_options
      parse_options
      create(PIK_HOME) unless PIK_HOME.exist?
      # Add.new(nil, config).execute if config.empty?
      delete_old_pik_batches
    end

    def close
      editors.each{|e| e.write }
    end
    
    def editors
      @editors ||= []
    end
    
    def command_options
    end
    
    def parse_options
      options.parse! @args
    end
   
    def current_version?(string)
      string == get_version
    end
        
    def get_version(path=current_ruby_bin_path)
      cmd = Pathname.new(path) + 'ruby.exe'
      ruby_ver = `#{cmd} -v`
      ruby_ver =~ /ruby (\d\.\d\.\d)/
      major    = $1.gsub('.','')
      "#{major}: #{ruby_ver.strip}"
    end
        
    def current_ruby_bin_path
      Pathname.new(::RbConfig::CONFIG['bindir'] )
    end

    def ruby_exists_at?(path)
      File.exist?("#{path}/ruby.exe")
    end

    def current_gem_bin_path
      default_gem_home + 'bin'
    end

    def default_gem_home
      Pathname.new(Gem.default_path.first).to_windows
    end
    
    def create(home)
      puts "creating #{home}"
      home.mkpath
    end
   
    def delete_old_pik_batches
      one_day_ago = Time.now - (2 * 60 * 60)
      Dir[(PIK_HOME + "*.bat").to_windows].each do |f| 
        File.delete(f) if File.ctime(f) < one_day_ago 
      end
    end

    # Installs a sigint handler.
  
    def add_sigint_handler
      trap 'INT' do
        raise QuitError
      end
    end
    
  end  
    
end