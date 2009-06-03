class Pik
  
  class QuitError < StandardError
  end

  class Runner

    def self.execute
      new.execute
    end

    def initialize
      @options   = {}
      @config    = Config.new{|h,k| h[k] = Hash.new }
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
      add_sigint_handler
      create(PIK_HOME) unless File.exist?(PIK_HOME)
      
      init_config if @config.empty?

      @pik_batch = BatchFile.new(File.join(PIK_HOME, "#{File.basename($0)}.bat") ) 
      update_gem_batch
      
      begin
        @commands = ['help'] if @commands.empty?
        send(*@commands) 
      rescue ArgumentError 
        help(@commands.first)
        exit 1
      rescue QuitError
        help('quit')
      ensure 
        @config.write
        @pik_batch.write
        puts
      end   
    end
    
    def run(command)
      current_dir = @config[get_version]
      @config.sort.each do |version,hash|
        ruby_dir = hash[:path]
        @pik_batch.echo " == Running with #{version} == "
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
        @config[version][:path] = path
      else
        help('no_ruby')
      end
    end
    alias :init_config :add

    def add_gem_home(*patterns)
      to_add = choose_from(patterns)
      new_dir = @hl.ask("Enter a path to a GEM_HOME dir")
      if @hl.agree("Add a GEM_HOME and GEM_PATH for '#{to_add}'? [Yn] ")
        @config[to_add][:gem_home] = new_dir
        @hl.say("GEM_HOME and GEM_PATH added for:  #{to_add} ")
      end
    end

    def remove(*patterns)
      to_remove = choose_from(patterns)
      raise QuitError unless to_remove
      if @hl.agree("Are you sure you'd like to remove '#{to_remove}'? [Yn] ")
        @config.delete(to_remove)
        @hl.say("#{to_remove} removed")
      end
    end
    alias :rm :remove

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
        switch_path_to(@config[new_ver][:path])
        switch_gem_home_to(@config[new_ver][:gem_home]) if @config[new_ver][:gem_home] 
      else
        abort
      end      
    end
    alias :sw :switch
    
    def help(arg='help')
      @arg = arg
      msg = message[@arg] || message['no_help']
      @hl.say(msg)
      puts
    end

    def message
      @messages ||= YAML.load(File.read(@msg_file))
    end

    def method_missing(meth)
      abort "The command #{meth} isn't recognized"
    end
    
    private
    
    def switch_path_to(ruby_dir)
      dir = current_dir.gsub('/', '\\')
      new_path = SearchPath.new(ENV['PATH']).replace_or_add(dir, ruby_dir).join
      @pik_batch.set('PATH' => WindowsFile.join(new_path) )
    end

    def switch_gem_home_to(gem_home_dir)
      @pik_batch.set('GEM_PATH' => WindowsFile.join(gem_home_dir) )
      @pik_batch.set('GEM_HOME' => WindowsFile.join(gem_home_dir) )
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
        menu.choice('q]uit'){raise QuitError}
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

  # Installs a sigint handler.

  def add_sigint_handler
    trap 'INT' do
      raise QuitError
    end
  end

  end

end
