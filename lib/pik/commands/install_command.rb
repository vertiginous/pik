
module Pik

  class  Install < Command

    include Installer
   
    aka :in
    it "Downloads and installs different ruby versions."

    def install_root
      @install_root ||= config.global.fetch(:install_dir, Pik.home + 'rubies')
    end
    
    def execute
      name = @args.shift
      ruby = Rubies[name]
      abort "#{name} not found" unless ruby
      
      Log.info("Installing #{ruby[:name]}")
      
      @target = install_root + ruby[:name]
      handle_target if @target.exist?
      
      file = download(ruby[:url],ruby)

      extract(@target, file)

      add(@target)
    end
    
    def command_options
      super
      sep =<<SEP
  Choices are: ruby, jruby, or ironruby
  
  If no version is specified, the latest version will be installed.
  You can see the full list by running 'pik list known'.

  Examples:

    # install the latest version of JRuby (currently 1.5.6)
    >pik install jruby

    # install the latest 1.8.7 version of MRI Ruby 
    >pik install ruby-1.8.7    

SEP
      options.separator sep
      options.on("--force", "Overwrite existing installation") do |value|
        @force = value
      end 
    end
    
    def handle_target
      if @force
        Log.info "Removing #{@target}"
        FileUtils.rm_rf @target
      else
        msg =  "\nThe directory '#{@target}' already exists.\n"
        msg << "Run:\n\n   'pik install --force [ruby]'\n\n" 
        msg << "if you want to replace it.\n"
        abort msg
      end
    end

    def add(target)
      p = Pik::Add.new([target + 'bin'], config)
      p.execute
      p.close
    end
    
  end
  
end