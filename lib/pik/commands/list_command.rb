module Pik

  class  List < Command
    
    aka :ls
    it "Lists ruby versions that pik is aware of."

    attr_reader :verbose, :remote
    
    def execute 
      if remote
        remote_list
      else
        list
      end
    end
    
    def remote_list
      puts Implementations.list.to_yaml
    end
    
    def list
      current_path = Which::Ruby.find
      config.sort.each do |name, conf|
        name += ' *' if current_path == conf[:path]
        puts name
        if verbose
          conf.each{|k,v| puts "     %s: %s" % [k, v]} 
          puts
        end
      end
    end
    
    private
    
    def command_options
      super
      @options.on("--verbose", "-v",
         "Verbose output"
         ) do |value|
        @verbose = value
      end
      @options.on("--remote", "-r",
         "List remote install packages"
         ) do |value|
        @remote = value
      end
    end
    
  end   
    
end