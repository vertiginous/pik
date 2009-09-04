require 'yaml'

module Pik

  class ConfigFile < Hash
      
    def initialize
      @file = File.join(PIK_HOME, 'config.yml')
      super{|h,k| h[k] = Hash.new }
      if File.exists? @file
        self.update( YAML.load( File.read( @file ) ) )
      end
    end

    def write
      File.open(@file, 'w'){|f| f.puts YAML::dump(Hash[self]) }
    end

  end

end
