module Pik

  class  GemDup < Command
  
    it "Duplicates gems from one Ruby version to another."
    include BatchFileEditor
    
    def execute
      target  = choose_from(@args)
      current = get_version
      install_gems(current, target) if target
    end
    
    def install_gems(current, target)
      switch_path_to(config[target])
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
    end
    
    def gem_cache(version)
      conf = config[version]
      
      path = if conf[:gem_home] 
        Pathname.new( conf[:gem_home] )
      else
        cmd = conf[:path] + "/ruby.exe -rubygems -e \"puts Gem.default_path.last\""
        Pathname.new( `#{cmd}`.chomp ) 
      end
      puts path + "cache"
      path + "cache"
    end
    
    def gem_install(file)
      @batch.echo "Installing #{file.basename}"
      @batch.call "gem install -q --no-rdoc --no-ri #{file}"
    end
  
  end

end