module Pik

  class  List < Command
    
    aka :ls
    it "Lists ruby versions that pik is aware of."

    attr_reader :verbose 
    
    def execute
      config.sort.each do |name, conf|
        name += ' *' if current_version?(name)
        puts name
        conf.each{|k,v| puts "     %s: %s\n\n" % [k, v]} if verbose
      end
    end
    
    private
    
    def command_options
      @options.on("--verbose", "-v",
         "Verbose output"
         ) do |value|
        @verbose = value
      end
    end
    
  end   
    
end