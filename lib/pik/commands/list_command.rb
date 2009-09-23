module Pik

  class  List < Command
    
    aka :ls
    it "Lists ruby versions that pik is aware of."

    attr_reader :verbose 
    
    def execute
      config.sort.each do |name, conf|
        name += ' *' if current_version?(name)
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
    end
    
  end   
    
end