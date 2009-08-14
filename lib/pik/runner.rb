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
        when '-d', '--default'
          @options[:default] = true
        end
      end
    end
    
    def execute
      add_sigint_handler
      create(PIK_HOME) unless File.exist?(PIK_HOME)
      init_config if @config.empty?
      delete_old_pik_batches

      @pik_batch = BatchFile.new(File.join(PIK_HOME, "#{File.basename($0)}_#{$$}.bat") ) 
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
      current_ruby = @config[get_version]
      @config.sort.each do |version,hash|
        switch_path_to(hash)
        @pik_batch.echo_running_with_ruby_version
        @pik_batch.call command
        @pik_batch.echo "."
      end
      switch_path_to(current_ruby)
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
      to_add = get_version
      new_dir = @options[:default] ? Gem.default_path.first : @hl.ask("Enter a path to a GEM_HOME dir")
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
        switch_path_to(@config[new_ver])
        switch_gem_home_to(@config[new_ver][:gem_home])
        @pik_batch.echo_ruby_version
      else
        abort
      end      
    end
    alias :sw :switch
    alias :use :switch
    
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
    
    def switch_path_to(new_ver)
      dir = current_ruby_bin_path.gsub('/', '\\')
      new_path = SearchPath.new(ENV['PATH']).replace_or_add(dir, new_ver[:path])
      if new_ver[:gem_home]
        new_path.replace_or_add(current_gem_bin_path, File.join(new_ver[:gem_home], 'bin'))
      else
        new_path.remove(current_gem_bin_path)
      end
      @pik_batch.set('PATH' => new_path.join )
    end

    def switch_gem_home_to(gem_home_dir)
      @pik_batch.set('GEM_PATH' => WindowsFile.join(gem_home_dir || '') )
      @pik_batch.set('GEM_HOME' => WindowsFile.join(gem_home_dir || '') )
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
    
    def get_version(path=current_ruby_bin_path)
      ruby = File.join(path, 'ruby.exe')
      ruby_ver = `#{path}/ruby.exe -v`
      ruby_ver =~ /ruby (\d\.\d\.\d)/
      major    = $1.gsub('.','')
      "#{major}: #{ruby_ver.strip}"
    end
        
    def current_ruby_bin_path
      ::RbConfig::CONFIG['bindir'] 
    end

    def current_gem_bin_path
      File.join(default_gem_home, 'bin')
    end

    def default_gem_home
      Gem.default_path.first.gsub("\\","/")
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
        # remove old calls to .pik/pik batches
        data = batch.file_data.reject{ |i| i =~ /call.+pik.+bat/i }
        batch.file_data = data
        
        # call new .pik/pik batch
        batch.call("\"#{WindowsFile.join(@pik_batch.file_name)}\"").write
      end
    end

    def delete_old_pik_batches
      one_day_ago = Time.now - (2 * 60 * 60)
      Dir[File.join(PIK_HOME, "*.bat").gsub("\\","/")].each do |f| 
        File.delete(f) if File.ctime(f) < one_day_ago 
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
