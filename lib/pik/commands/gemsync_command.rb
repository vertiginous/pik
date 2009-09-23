module Pik

  class  GemSync < Command
  
    it "Duplicates gems from the current version to the one specified."
    include BatchFileEditor
    
    def execute
      target  = self.class.choose_from(@args, config)
      current = get_version
      install_gems(current, target) if target
    end
    
    def install_gems(current, target)
      switch_path_to(config[target])
      switch_gem_home_to(config[target][:gem_home]) 
      target_cache = gem_cache(target)
      
      gem_cache(current).find do |file|
        if file.file?
          if (target_cache + file.basename).exist? 
            @batch.echo "Gem #{file.basename} already installed"
          else
            gem_install(file)
          end
        end
      end
      switch_path_to(config[current])
      switch_gem_home_to(config[target][:gem_home]) 
    end
    
    def gem_cache(version)
      conf = config[version]
      path = if conf[:gem_home] 
        Pathname.new( conf[:gem_home] )
      else
        cmd = ruby_exe(conf[:path]).to_s + " -rubygems -e \"puts Gem.default_path.last\""
        Pathname.new( `#{cmd}`.chomp ) 
      end
      puts path + "cache"
      path + "cache"
    end
    
    def gem_install(file)
      @batch.echo "Installing #{file.basename}"
      @batch.call "gem install -q --no-rdoc --no-ri #{file}"
    end
    
    def command_options
      super
      sep =<<SEP
  Examples:

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
    end
  
  end

end