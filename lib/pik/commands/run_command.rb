module Pik

  class  Run < Command
  	
  	it "Runs command with all versions of ruby that pik is aware of."

    def execute
      check_args
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

    def switch_path_to(other)
      current = Which::Ruby.find
      
      new_path = SearchPath.new(ENV['PATH'])
      new_path.replace_or_add(current, other[:path])
      
      # if there is currently a GEM_HOME, remove it's bin dir from the path
      new_path.remove(Pathname.new(ENV['GEM_HOME']) + 'bin') if ENV['GEM_HOME']
      
      # if the new version has a GEM_HOME, add it's bin dir to the path
      new_path.add(Pathname.new(other[:gem_home]) + 'bin') if other[:gem_home]
      
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
    
    def check_args
      if args_required? && @args.empty?
        raise "The #{cmd_name} command must be called with an argument"
      end
    end
    
    def args_required?
      true
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

  class Rake < Run
  
    it "Runs the rake command with all versions that pik is aware of."
    
    def command(cmd=Which::Rake.bat.basename)
      super(cmd)
    end
    
    def help_message
      sep =<<SEP
  Examples:

    C:\\>pik rake spec

SEP
    end
    
    def args_required?
      false
    end
    
  end

end

