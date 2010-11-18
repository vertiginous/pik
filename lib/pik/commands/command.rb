require 'optparse'

module Pik

  class PrettyError < StandardError
    def backtrace
      []
    end
  end

  class VersionUnknown < StandardError
  end

  class QuitError < PrettyError
  end

  class GemSetMissingError < PrettyError
    def message
      "Gemset '#{super}' does not exist, pik gemset create #{super} first."
    end
  end
  
  class  Command

    attr_reader :args  #TODO: change all @args to args

    attr_reader :config
    
    attr_reader :log   #TODO: change all @log to log
        
    attr_reader :options
    
    attr_accessor :env

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
    
    def self.choose_from(args, config) # use config, fix install
      imp, gemset = args.first.split(/@/)
      
      # gemset  = "--gemset=#{gemset}" if gemset
      return {:ver => config.default.to_a} if args.include? 'default'
      
      matches = config.matches(imp)
      matches.size.zero? ? nil : {:ver => matches.max, :gemset => gemset}
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
      @hl.page_at = :auto

      #overridden by ScriptFileEditor
      @env          = ENV

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
   
    def current_version?(string) # is this used anywhere?
      string == get_full_version
    end

    def get_full_version(path=Which::Ruby.find)
      cmd = Which::Ruby.exe(path)
      ruby_ver = `"#{cmd}" -v`.strip
    end

    def get_short_version(path=Which::Ruby.find)
      ruby_ver = get_full_version(path)
      VersionParser.parse(ruby_ver).short_version
    end
    
    def find_config_from_path(path=Which::Ruby.find)
      # raise PrettyError, "No ruby found, do you have a ruby selected?" unless path
      ver = config.reject{|ver,cfg| cfg == 'default' }.each{|ver,cfg| 
        return ver if Pathname(cfg[:path]) == Pathname(path)
      }
      nil
    end

    def current_ruby_short_version
      current = find_config_from_path
      raise unless current
      VersionParser.parse(current[:version]).short_version
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
      gs = "@#{gemset}" if gemset
      gemset_root + "#{version}#{gs}"
    end

    def gemset_global(version)
      gemset_gem_home(version, 'global')
    end
            
    def create(home)
      log.info "creating #{home}"
      home.mkpath
      ['scripts','gems','rubies','config','downloads'].each{|dir| (home + dir).mkpath}
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
    
    #TODO, make this gemset aware
    def switch_path_to(path, gem_path)
      current = Which::Ruby.find
      
      new_path = SearchPath.new(ENV['PATH'])
      new_path.replace_or_add(current, path)

      # remove old gemset bin dirs from the path
      new_path.reject!{|i| i =~ /\.pik.gems/}
      
      # add new bin dir to the path
      gem_path.each{|gem_home| new_path.add_before(path, (Pathname(gem_home) + 'bin')) }
      
      log.info "PATH=#{new_path}" if debug
      env['PATH'] = new_path.join
    end

    def switch_gem_home_to(gem_home)
      gem_home = Pathname(gem_home).to_windows rescue nil
      if debug
        # puts "GEM_PATH=#{gem_home}"
        puts "GEM_HOME=#{gem_home}"
      end
      # env['GEM_PATH'] = gem_home
      env['GEM_HOME'] = gem_home.to_s
    end

    #TODO, make this global gemset aware
    def switch_gem_path_to(gem_path)
      if debug
        puts "GEM_PATH=#{gem_path}"
      end
      env['GEM_PATH'] = gem_path.to_s    
    end

    def switch_bundle_path_to(bundle_path)
      if debug
        puts "BUNDLE_PATH=#{bundle_path}"
      end
      env['BUNDLE_PATH'] = bundle_path    
    end

    # Installs a sigint handler.
  
    def add_sigint_handler
      trap 'INT' do
        raise QuitError
      end
    end
    
  end  
    
end
