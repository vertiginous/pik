class Pik

  class Runner #< ::HighLine

    def self.execute
      new.execute
    end

    def initialize
      @options   = {}
      @config    = Config.new
			@msg_file  = File.join(File.dirname(__FILE__), '..', '..', 'messages','messages.yml')
			@hl        = HighLine.new
			
      options, @commands = ARGV.partition{ |a| a =~ /^-/ }
      options.each do |option|
        case option
        when '-g', '--global'
          @options[:global] = true
        when '-i', '--interactive'
          @options[:interactive] = true
        end
      end
    end
    
    def execute
      create(PIK_HOME) unless File.exist?(PIK_HOME)
      
      init_config if @config.empty?

      @pik_batch = BatchFile.new(File.join(PIK_HOME, "#{File.basename($0)}.bat") ) 
      update_gem_batch
      
      # begin
				@commands = ['help'] if @commands.empty?
        send(*@commands) 
        @config.write
        @pik_batch.write
      # rescue ArgumentError
      #   text(@commands.first)
      #   exit 1
      # end   
			puts
    end
		
		def run(command)
			current_dir = @config[get_version]
			@config.sort.each do |version,ruby_dir|
				@pik_batch.echo "Running with #{version}"
				switch_path_to(ruby_dir)
				@pik_batch.call command
				@pik_batch.echo "."
			end
			switch_path_to(current_dir)
		end
		
    def add(path=::Config::CONFIG['bindir'])
			return add_interactive if @options[:interactive]
      if File.exist?("#{path}/ruby.exe")
				version = get_version(path)
				path    = File.expand_path(path).gsub('\\','/')
				puts "Adding:  #{version}'\n Located at:  #{path}\n"
        @config[version] = path
      else
        help('no_ruby')
      end
    end
		alias :init_config :add

		def rm(*patterns)
			to_rm = choose_from(patterns)
			if @hl.agree("Are you sure you'd like to remove '#{to_rm}'? [Yn] ")
				@config.delete(to_rm)
				@hl.say("#{to_rm} removed")
			end
		end
		
    def checkup
      puts Checkup.new(message).check
    end

    def config(*args)
      item, value = args.shift.downcase.split('=')
      case item
      when 'home'
        if value
          set('HOME' => value)
        else
          set('HOME' => "#{ENV['HOMEDRIVE']}#{ENV['HOMEPATH']}")
        end
      when 'rubyopt'
        case value
        when 'on'  then set('RUBYOPT' => '-rubygems')
        when 'off' then set('RUBYOPT' => nil)
        end
      end
    end
		
		def list
			puts @config.keys.sort
		end
		alias :ls :list

    def switch(*patterns)
			new_ver  = choose_from(patterns)
			if new_ver
				@hl.say "Switching to #{new_ver}"
				switch_path_to(@config[new_ver])
			else
				abort
			end			
    end

    def help(arg='help')
      @hl.say(message[arg])
    end

		def message
			@messages ||= YAML.load(File.read(@msg_file))
		end

    def method_missing(meth)
      if @config[meth]
        switch[meth]
      else
        abort "The command #{meth} isn't recognized"
      end
    end
    
    private
		
		def switch_path_to(ruby_dir)
			dir = current_dir.gsub('/', '\\')
			new_path = SearchPath.new(ENV['PATH']).replace_or_add(dir, ruby_dir).join
			@pik_batch.set('PATH' => WindowsFile.join(new_path) )
		end

		def add_interactive
			@options.delete(:interactive)
			@hl.choose do |menu|	
				menu.prompt = ""
				menu.choice('e]nter a path'){
					dir = @hl.ask("Enter a path to a ruby/bin dir (enter to quit)")
					add(dir) unless dir.empty? || !@hl.agree("Add '#{dir}'? [Yn] ")
					add_interactive
				}
				menu.choice('s]earch'){
					search_dir = @hl.ask("Enter a search path")
					files = Dir[File.join(search_dir, '**','ruby.exe').gsub('\\','/')]
					files.each{|file| 
						dir = File.dirname(file)
						add(dir) if @hl.agree("Add '#{dir}'? [Yn] ")
					}
					add_interactive
				}
				menu.choice('q]uit')
			end				
		end

		def choose_from(patterns)
			if patterns.empty?
				possibles = @config.keys	
			else
				possibles = patterns.map{|p| @config.keys.grep(Regexp.new(p)) }
				possibles = possibles.inject{|m,v| m & v }.flatten.uniq
			end

			case possibles.size
			when 0
				@hl.say 'Nothing matches:'
				return nil
			when 1
				return possibles.first
			else
				@hl.say('Select which Ruby you want:')
			  ver = @hl.choose(*possibles)
				return ver
			end
		end
		
		def get_version(path=current_dir)
			ruby = File.join(path, 'ruby.exe')
			ruby_ver = `#{path}/ruby.exe -v`
      ruby_ver =~ /ruby (\d\.\d\.\d)/
      major    = $1.gsub('.','')
			"#{major}: #{ruby_ver.strip}"
		end
				
		def current_dir
			::RbConfig::CONFIG['bindir'] 
		end
	
		def set(items)
      items.each do |k, v|
        @pik_batch.set(k => v)
        WindowsEnv.user.set(k => v) if @options[:global]
      end
    end
    
    def create(home)
      puts "creating #{home}"
      FileUtils.mkpath(home) 
    end

    def update_gem_batch
      BatchFile.open("#{$0}.bat") do |batch|
				case batch.file_data.last 
				when Regexp.new( PIK_HOME.gsub(/\\/, '\&\&') )
          puts batch.file_data.last
				when /call/i
          batch.file_data.pop
          batch.call("\"#{WindowsFile.join(@pik_batch.file_name)}\"").write
				else
					batch.call("\"#{WindowsFile.join(@pik_batch.file_name)}\"").write
        end
      end
    end

  end

end
