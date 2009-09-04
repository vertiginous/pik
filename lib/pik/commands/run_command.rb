module Pik

  class  Run < Command
  	
  	it "Runs command with all version of ruby that pik is aware of."
    include BatchFileEditor

    def execute
      command = @args.join(' ')
      current_ruby = @config[get_version]
      @config.sort.each do |version,hash|
        switch_path_to(hash)
        switch_gem_home_to(hash[:gem_home])
        echo_running_with_ruby_version
        @batch.call command
        @batch.echo "."
      end
      switch_path_to(current_ruby)
      switch_gem_home_to(current_ruby[:gem_home])
    end
  
  end
  
end