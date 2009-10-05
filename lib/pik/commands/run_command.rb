module Pik

  class  Run < Command
  	
  	it "Runs command with all versions of ruby that pik is aware of."
    include BatchFileEditor
    
    attr_accessor :verbose

    def execute
      command = @args.join(' ')
      current_ruby = @config[find_config_from_path]
      @config.sort.each do |version,hash|
        switch_path_to(hash)
        switch_gem_home_to(hash[:gem_home])
        echo_ruby_version(hash[:path], 'Running with') if verbose
        @batch.call command
        @batch.echo "."
      end
      switch_path_to(current_ruby)
      switch_gem_home_to(current_ruby[:gem_home])
    end
    
    def command_options
      super
      
      options.on("--verbose", "-v",
         "Display verbose output"
         ) do |value|
        @verbose = true
      end
      
      sep =<<SEP
  Examples:

    C:\\>pik run "ruby -v"

    C:\\>pik run "rake spec"

SEP
      options.separator sep  
    end

  end
  
end