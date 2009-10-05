module Pik

  class  Add < Command
  	    
    it 'Adds another ruby location to pik.'
    include ConfigFileEditor

    attr_reader :interactive 

    def execute(path=nil)
      return add_interactive if interactive
      path = @args.first || first_ruby_in_path
      add(path)
    end

    def add(path)
      path = Pathname.new(path)
      path = path.dirname if path.file?
      if ruby_exists_at?(path) 
        if find_config_from_path(path)
          puts "This version has already been added."
        else
          version = get_version(path)
          path    = path.expand_path.to_ruby
          puts "Adding:  #{version}\n Located at:  #{path}\n"
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
        menu.choice('e]nter a path'){
          dir = @hl.ask("Enter a path to a ruby/bin dir (enter to quit)")
          execute(dir) unless dir.empty? || !@hl.agree("Add '#{dir}'? [Yn] ")
          add_interactive
        }
        menu.choice('s]earch'){
          search_dir = @hl.ask("Enter a search path")
          files = ruby_glob(search_dir + '**')
          files.each{|file| 
            dir = File.dirname(file)
            add(dir) if @hl.agree("Add '#{dir}'? [Yn] ")
          }
          add_interactive
        }
        menu.choice('q]uit'){raise QuitError}
      end        
    
    end
  end

end