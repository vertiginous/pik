
module Pik

  class  GemSync < Command
  
    it "Synchronizes gems from the version specified to the current version."
    
    attr_reader :remote, :quiet
    
    def execute
      source  = self.class.choose_from(@args, config)
      raise "Couldn't find a version from the pattern given: '#{@args.join(' ')}'" unless source
      current = find_config_from_path
      
      if platform_consistent?(source, current)
        puts "** Syncing: #{current}\n   with: #{source}"
        puts "   from a remote repository." if remote
        puts
        install_gems(current, source)
      end
    end
    
    def platform_consistent?(source, current)
      s_platform = VersionParser.parse(source).platform
      c_platform = VersionParser.parse(current).platform
      return true if s_platform == c_platform || remote
      msg =<<MSG
  You appear to be attempting a gemsync from a different platform.  
  
    Sync: #{current}
    with: #{source}

  If you really want to sync, I recommend you quit and run gemsync with
  the --remote flag.

MSG
      raise msg if quiet
      @hl.agree(msg + "Are you sure you'd like to continue?"){|answer| answer.default = 'no'}
    end
    
   def install_gems(current, source)
      target_cache = gem_cache(current)
      
      gem_cache(source).find do |file|
        if file.file?
          if (target_cache + file.basename).exist? 
            puts "** Gem #{file.basename('.gem')} already installed"
          else
            puts "** Installing #{file.basename('.gem')}"
            cmd = "#{Which::Gem.exe} install -q --no-rdoc --no-ri #{gem_file(file)}"
            puts cmd if debug
            system(cmd)
          end
        end
      end
    end
    
    def gem_file(file)
      if remote
        gem_re = /(.+)\-(\d+\.\d+\.\d+).+/
        file, gem_name, version = file.basename.to_s.match(gem_re).to_a
        "#{gem_name} --version \"=#{version}\""
      else
        file
      end
    end
    
    def gem_cache(version)
      conf = config[version]
      cmd = Which::Ruby.exe(conf[:path]).to_s + " -rubygems -e \"puts Gem.default_path.last\""
      
      path = conf[:gem_home] ? Pathname( conf[:gem_home] ) : Pathname( `#{cmd}`.chomp ) 
      path + "cache"
    end
    
    def command_options
      super
      sep =<<SEP
  Gemsync syncs the current version of ruby with the one given.    
  
  This tool is fairly dumb. Syncing across implementations is 
  probably a bad idea.
      
  Examples:
    
    syncs ruby 1.8.6 with the gems install for 1.9.1

    C:\\>ruby -v
    ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]
    
    C:\\>pik gemsync 191 p2
    Gem ZenTest-4.1.4.gem already installed
    Installing xml-simple-1.0.12.gem
    Successfully installed xml-simple-1.0.12
    1 gem installed
    ...
SEP
      options.separator sep
      
      options.on("--quiet", "-q", "Sync without prompting, fails if platforms don't match") do |value|
        @quiet = value
      end
      options.on("--remote", "-r", "Pull gems from a remote repository") do |value|
        @remote = value
      end
    end
  
  end

end