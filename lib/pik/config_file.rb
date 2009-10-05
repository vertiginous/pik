require 'yaml'

module Pik

  class ConfigFile < Hash
      
    def initialize
      @file = File.join(PIK_HOME, 'config.yml')
      super
      if File.exists? @file
        contents = File.read( @file )
        self.update( YAML.load( contents ) ) unless contents.empty?
      end
    end

    def write
      File.open(@file, 'w'){|f| f.puts YAML::dump(Hash[self]) }
    end

  end

end
