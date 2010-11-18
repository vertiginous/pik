
module Pik

  class  Gemset < Command
  
    it "Manages gem sets"
    include ScriptFileEditor
    
    def execute
      actions = ['create','select','clear','dump','export','load','import','name','list','dir','delete']
      action  = @args.shift
      case action
      when *actions
        send(action)
      else
        raise PrettyError, 
          "Unrecognized gemset action '#{action}'.\n\n" +
          "Valid gemset actions are: {#{actions.join(",")}}"
      end
    end
    
    # gems subcommands  
  
    def create
      gem_home = gemset_gem_home(find_config_from_path, args.shift)
      FileUtils.mkdir_p(gem_home.to_ruby)
      log.info("Gemset #{gem_home} created")
    end

    def select
      gem_home = gemset_gem_home(find_config_from_path, @args.shift)
      switch_gem_home_to(gem_home)
    end
    
    # selects default GEM_HOME
    def clear
      gem_home = @config[find_config_from_path][:gem_home]
      switch_gem_home_to(gem_home)
    end
      
    def dump
      gemset_file = @args.first || "#{gem_set_name}.gems"
      File.open(gemset_file, 'w+'){ |f| f.puts gem_set_dump }
    end
    alias export dump

    def load
      File.read(@args.first).split("\n").each do |gem_set_item|
        next if gem_set_item.match(/^\s*#/)
        if gem_set_dump.include? gem_set_item
          log.info("Gem #{gem_set_item} already installed")
        else
          log.info("Installing #{gem_set_item}")
          sh "#{gem_cmd} install -q --no-rdoc --no-ri #{gem_set_item}"
        end
      end
    end
    alias import load
    
    def name
      puts gem_set_name
    end
    
    def list
      short_version = find_config_from_path
      puts
      log.info("gemsets : for #{short_version} (found in #{gemset_root.to_windows})")
      x = gemset_root + "#{short_version}@*"
      Pathname.glob(x.to_ruby).each do |gemset|
        puts gemset.basename.to_s.split('@').last if gemset.directory?
      end
    end
    
    def dir
      puts ENV['GEM_HOME'] || actual_gem_home
    end
    
    def delete
      # to_delete = @args.first
      # if to_delete.nil?
      #   raise "A gemset must be specified in order to delete."
      # else
      #   if 
      # end
    end
    
    # helper methods
    
    def gem_set_name
      ENV['GEM_HOME'] ? Pathname(ENV['GEM_HOME']).basename : 'default'
    end
    
    def gem_set_dump
      @gem_set_dump ||= `#{gem_cmd} list`.
      scan(/(.+) \((.+)\)/).
      map{|name, versions| versions.split(', ').map{|version| "#{name} -v#{version}" } }.
      flatten
    end
    
    def gem_cmd
      Which::Gem.exe.basename
    end
     
  end
  
end