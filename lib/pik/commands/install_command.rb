
module Pik

  class  Install < Command

    include Installer
   
    aka :in
    it "Downloads and installs different ruby versions."

    def install_root
      @install_root ||= config.global.fetch(:install_dir, Pik.home + 'rubies')
    end
    
    def execute
      list = config.options.fetch(:versions, @args.shift)
      list.split(',').each{|name| install(name) }
    end

    def install(name)
      ruby = Rubies[name]
      abort "#{name} not found" unless ruby

      check_7zip
            
      Log.info("Installing #{ruby[:name]}")
      
      @target = install_root + ruby[:name]

      if target_allowed?
        file = download(ruby[:url],ruby)
        extract(@target, file)
        add(@target)
      end
    end
    
    def command_options
      super
      sep =<<SEP
  Choices are: 1.8.7, 1.9.2, jruby, or ironruby
  
  If no version is specified, the default version will be installed.
  You can see the full list by running 'pik list known'.

  Examples:

    # install the default version of JRuby (currently 1.5.6)
    >pik install jruby

    # install the default 1.8.7 version of MRI Ruby 
    >pik install ruby-1.8.7
    
    # install a version with a patchlevel
    >pik install ruby-1.8.7-p248

    # install all most recent stable versions
    > pik install 1.8.7,1.9.2,ironruby,jruby

SEP
      options.separator sep
      options.on("--force", "Overwrite existing installation") do |value|
        @force = value
      end 
    end
    
    def target_allowed?
      if @target.exist?
        if @force
          Log.info "Removing #{@target}"
          FileUtils.rm_rf @target
          true
        else
          msg =  "The directory '#{@target}' already exists.\n\n"
          msg << "Run:\n\n   'pik install --force [ruby]'\n\n" 
          msg << "if you want to replace it.\n"
          Log.error msg
          false
        end
      else
        true
      end
    end

    def add(target)
      p = Pik::Add.new([target + 'bin'], config)
      p.execute
      p.close
    end
    
  end
  
end