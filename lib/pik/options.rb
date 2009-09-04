require 'optparse'

module Pik

  class Options
  
    attr_reader :global
  
    attr_reader :interactive
  
    attr_reader :default
  
    attr_reader :verbose
  
    
    def self.parse(args)
      new(args).parse
    end
    
    def initialize(args)
      @args = args
    end
    
    def parse
      opts = OptionParser.new do |opt|
        opt.program_name = File.basename $0
          opt.on("--global", "-g"
             "change the option globally."
             ) do |value|
            @global = value
          end
    
          opt.on("--verbose", "-v"
             "Verbose output"
             ) do |value|
            @verbose = value
          end
          
          opt.on("--interactive", "-i"
             "run the command interactively"
             ) do |value|
            @interactive = value
          end
                  
          opt.on("--default", "-d"
             "perform the default action"
             ) do |value|
            @default = value
          end
    
      end
    end
      
  end
  
end