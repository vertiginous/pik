module Pik

  class  Run < Command
  	
  	it "Runs command with all versions of ruby that pik is aware of."
    
    attr_accessor :verbose

    def execute
      @config.sort.each do |version,hash|
        switch_path_to(hash)
        switch_gem_home_to(hash[:gem_home])
        echo_ruby_version(hash[:path], 'Running with') if verbose
        puts command if verbose
        puts `#{command}`
        puts
      end
    end
    
    def command
      @args.join(' ')
    end
    
    def command_options
      super
      
      options.on("--verbose", "-v",
         "Display verbose output"
         ) do |value|
        @verbose = true
      end
      
      sep =<<SEP
  Examples:

    C:\\>pik run "ruby -v"

    C:\\>pik run "rake spec"

SEP
      options.separator sep  
    end

    def switch_path_to(new_ver)
      dir = Which::Ruby.find
      current_config = config[ find_config_from_path(dir) ]
      
      new_path = SearchPath.new(ENV['PATH']).replace_or_add(dir, new_ver[:path])
      if new_gem_home = new_ver[:gem_home]
        
        new_gem_bin = Pathname.new(new_gem_home) + 'bin'
        
        if current_gem_home = current_config[:gem_home]
          current_gem_bin = Pathname.new(current_gem_home) + 'bin'
          new_path.replace(current_gem_bin, new_gem_bin)
        else
          new_path.add(new_gem_bin)
        end
      else
        if current_gem_home = current_config[:gem_home]
          current_gem_bin = Pathname.new(current_gem_home) + 'bin'
          new_path.remove(current_gem_bin)
        end
      end
      ENV['PATH'] = new_path.join
    end

    def switch_gem_home_to(gem_home_dir)
      if gem_home_dir
        gem_home_dir ||= ''
        gem_path = Pathname.new(gem_home_dir).to_windows 
        ENV['GEM_PATH'] = gem_path
        ENV['GEM_HOME'] = gem_path
      else
        ENV.delete 'GEM_PATH'
        ENV.delete 'GEM_HOME'
      end
    end
        
    def echo_ruby_version(path, verb='')
      rb = Which::Ruby.exe(path).basename
      puts `for /f \"delims=\" %a in ('#{rb} -v') do @echo #{verb} %a `
    end

  end

  class Ruby < Run
  
    aka :rb
    it "Runs ruby with all versions that pik is aware of."
    
    def command
      cmd = Which::Ruby.exe.basename
      "#{cmd} #{@args.join(' ')}"
    end
    
  end
  
  class Gem < Run
  
    it "Runs the gem command with all versions that pik is aware of."
    
    def command
      cmd = Which::Gem.bat.basename
      "#{cmd} #{@args.join(' ')}"
    end
    
  end
  
end

