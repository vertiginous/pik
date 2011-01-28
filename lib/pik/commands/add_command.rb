module Pik

  class  Add < Command
  	    
    it 'Adds another ruby location to pik.'
    include ConfigFileEditor

    def execute(path=nil)
      path = @args.first || Which::Ruby.find
      add(Pathname(path))
    end

    def add(path, options={})
      path = path.dirname if path.file?

      if Which::Ruby.exist?(path)
        if find_config_from_path(path)
          puts "This version has already been added."
        else
          version  = get_version(path)
          name     = version.short_version
          name     = modify_version(name) if config[name]
          if found = Rubies[name]
            name   = found[:pattern]
          else
            name = name.gsub(/^(ruby\-)(.+)/, '[\1]\2')
          end
          
          path    = Pathname(path.expand_path.to_ruby)

          Log.info "Adding:  #{name}\n      Located at:  #{path}\n"
          
          config[name]            = {}
          config[name][:path]     = path
          config[name][:version]  = version.full_version
          config[name][:platform] = version.platform
          config[name][:alias]    = options[:alias] if options[:alias]
        end
      else
        puts "Couldn't find a Ruby version at #{path}"
      end
    end

    def command_options
      super
      options.banner += "[path_to_ruby]"
    end    

    def get_version(path=Which::Ruby.find)
      cmd = Which::Ruby.exe(path)
      ruby_ver = `"#{cmd}" -v`
      version  = VersionParser.parse(ruby_ver)
    end

    def modify_version(version)
      puts "This version appears to already be installed at this location:\n\n"
      puts "  #{config[version][:path]}\n\n"
      puts "If you'd still like to add this version, you can.\n\n"
      modifier = hl.ask("Enter a unique name to modify the name of this version. (enter to quit)")
      raise QuitError if modifier.empty?
      "#{version}-#{modifier}"
    end

  end

end