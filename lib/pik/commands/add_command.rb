module Pik

  class  Add < Command
  	    
    it 'Adds another ruby location to pik.'
    include ConfigFileEditor

    attr_reader :interactive 

    def execute(path=nil)
      return add_interactive if interactive
      path = @args.first || Which::Ruby.find
      add(path)
    end

    def add(path)
      path = Pathname.new(path)
      path = path.dirname if path.file?
      if Which::Ruby.exist?(path)
        if find_config_from_path(path)
          puts "This version has already been added."
        else
          version = get_version(path)
          version = modify_version(version) if config[version]
          path    = Pathname(path.expand_path.to_ruby)
          @log.info "Adding:  #{version}\n Located at:  #{path}\n"
          @config[version] = {}
          @config[version][:path] = path
        end
      else
        puts "Couldn't find a Ruby version at #{path}"
      end
    end

    def command_options
      super
      options.banner += "[path_to_ruby]"
      options.separator ""      
      options.on("--interactive", "-i", "Add interactively") do |value|
        @interactive = value
      end 
    end    

    def add_interactive
      @hl.choose do |menu|  
        menu.prompt = ""
        menu.choice('e]nter a path') do
          dir = @hl.ask("Enter a path to a ruby/bin dir (enter to quit)")
          execute(dir) unless dir.empty? || !@hl.agree("Add '#{dir}'?"){|answer| answer.default = 'yes' }
          add_interactive
        end
        menu.choice('s]earch') do
          search_dir = @hl.ask("Enter a search path")
          files = Which::Ruby.glob(search_dir + '**')
          files.uniq.each do |file| 
            dir = File.dirname(file)
            add(dir) if @hl.agree("Add '#{dir}'?"){|answer| answer.default = 'yes' }
          end
          add_interactive
        end
        menu.choice('q]uit'){raise QuitError}
      end        
    
    end

    def modify_version(version)
      puts "This version appears to exist in another location."
      puts "Path:  " + config[version][:path]
      puts "If you'd still like to add this version, you can."
      modifier = @hl.ask("Enter a unique name to modify the name of this version. (enter to quit)")
      raise QuitError if modifier.empty?
      ver = version.split(':')
      ["#{ver.shift}-#{modifier}", ver].join(':')
    end

  end

end