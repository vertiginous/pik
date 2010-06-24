require 'optparse'

module Pik

  class QuitError < StandardError
  end
  
  class VersionUnknown < StandardError
  end
  
  class  Command

    attr_reader :config
    
    attr_reader :options
    
    attr_accessor :output
    
    attr_accessor :version
    
    attr_accessor :debug
    
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

    def self.choose_from(patterns, config)
      if patterns.empty?
        possibles = config.keys  
      else
        possibles = patterns.map{|p| config.keys.grep(Regexp.new(Regexp.escape(p.to_s),Regexp::IGNORECASE) ) }
        possibles = possibles.inject{|m,v| m & v }.flatten.uniq
      end
      case possibles.size
      when 0
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
  
    def initialize(args=ARGV, config_=nil, log=Log.new)
      @args         = args
      @options      = OptionParser.new
      @config       = config_ || ConfigFile.new
      @log          = log
      @hl           = HighLine.new

      add_sigint_handler
      options.program_name = "pik #{self.class.names.join('|')}"
      command_options
      parse_options
      create(PIK_HOME) unless PIK_HOME.exist?
      delete_old_pik_script
    end

    def close
      editors.each{|e| e.write }
    end
    
    def editors
      @editors ||= []
    end
    
    def command_options
      options.separator ""
      options.separator self.class.summary
      options.separator ""
    end
    
    def parse_options
      options.on("--version", "-V", "Pik version") do |value|
        @version = true
        puts pik_version
      end
      options.on("--debug", "-d", "Outputs debug information") do |value|
        @debug = true
      end
      options.parse! @args 
    end
    
    def pik_version
      "pik " + Pik::VERSION
    end
   
    def current_version?(string)
      string == get_version
    end
        
    def get_version(path=Which::Ruby.find)
      cmd = Which::Ruby.exe(path)
      ruby_ver = `"#{cmd}" -v`
      ruby_ver =~ /ruby (\d\.\d\.\d)/i
      major    = $1.gsub('.','')
      "#{major}: #{ruby_ver.strip}"
    end
    
    def find_config_from_path(path=Which::Ruby.find)
      config.find{|k,v| 
        Pathname(v[:path])== Pathname(path)
      }.first rescue nil
    end

    def current_ruby_short_version
      VersionParser.parse(find_config_from_path).short_version
    end
  
    def current_gem_bin_path
      cfg = config[find_config_from_path]
      p = cfg[:gem_home] || default_gem_home 
      p + 'bin'
    end

    def default_gem_home
      gem_path.first
    end
    
    def actual_gem_home
      gem_path.last
    end
    
    def download_dir 
      config.global[:download_dir] || PIK_HOME + 'downloads'
    end

    def install_root
      config.global[:install_dir]  || PIK_HOME + 'rubies'
    end

    def gem_path
      `\"#{Which::Gem.exe}\" env gempath`.chomp.split(';').map{|p| Pathname(p).to_windows }
    end

    def gemset_root  
      PIK_HOME + 'gems'
    end
    
    def gemset_gem_home(version, gemset)
      ver = VersionParser.parse(version)
      gs = "@#{gemset}" if gemset
      gemset_root + "#{ver.short_version}#{gs}"
    end
            
    def create(home)
      puts "creating #{home}"
      home.mkpath
    end
   
    def delete_old_pik_script
      SCRIPT_FILE.path.delete if SCRIPT_FILE.path.exist?
    end
    
    def sh(cmd)
      puts cmd if debug
      system(cmd)
    end
    
    def cmd_name
      self.class.cmd_name
    end

    # Installs a sigint handler.
  
    def add_sigint_handler
      trap 'INT' do
        raise QuitError
      end
    end
    
  end  
    
end
