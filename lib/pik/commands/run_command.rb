module Pik

  class  Run < Command
  	
  	it "Runs command with all versions of ruby that pik is aware of."

    def execute
      @config.sort.each do |version,hash|
        begin
          switch_path_to(hash)
          switch_gem_home_to(hash[:gem_home])
          echo_ruby_version(hash[:path])
          system command
          puts
        rescue => e
          version = version.split(': ')[1..-1].join(': ')
          puts version
          Pik.print_error(e)
        end
      end
    end
    
    def command(cmd='CALL')
      args = @args.map{|a| a.sub(/.*\s.*/m, '"\&"')}.join(' ')
      "#{cmd} #{args}"
    end
    
    
    def command_options
      super
      options.separator help_message  
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik run PATH

    C:\\>pik run rake spec

SEP
    end
    
    def parse_options
    end

    def switch_path_to(new_ver)
      dir = Which::Ruby.find
      current_config = config[ find_config_from_path(dir) ]
      
      new_path = SearchPath.new(ENV['PATH']).replace_or_add(dir, new_ver[:path])
      if new_gem_home = new_ver[:gem_home]
        
        new_gem_bin = Pathname.new(new_gem_home) + 'bin'
        
        if current_config && (current_gem_home = current_config[:gem_home])
          current_gem_bin = Pathname.new(current_gem_home) + 'bin'
          new_path.replace(current_gem_bin, new_gem_bin)
        else
          new_path.add(new_gem_bin)
        end
      else
        if current_config && (current_gem_home = current_config[:gem_home])
          current_gem_bin = Pathname.new(current_gem_home) + 'bin'
          new_path.remove(current_gem_bin)
        end
      end
      ENV['PATH'] = new_path.join
    end

    def switch_gem_home_to(gem_home)
      gem_home = Pathname(gem_home).to_windows rescue nil
      ENV['GEM_PATH'] = gem_home
      ENV['GEM_HOME'] = gem_home
    end
        
    def echo_ruby_version(path)
      rb = Which::Ruby.exe(path)
      raise "Unable to find a Ruby executable at #{path}" unless rb
      puts `"#{rb}" -v `
    end

  end

  class Ruby < Run
  
    aka :rb
    it "Runs ruby with all versions that pik is aware of."
    
    def command(cmd=Which::Ruby.exe.basename)
      super(cmd)
    end

    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik ruby -v

    C:\\>pik rb -e "puts 'Hello world!'"

SEP
    end
    
  end
  
  class Gem < Run
  
    it "Runs the gem command with all versions that pik is aware of."
    
    def command(cmd=Which::Gem.bat.basename)
      super(cmd)
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik gem list

    C:\\>pik gem install my_gem

SEP
    end
    
  end
  
end

