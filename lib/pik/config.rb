require 'yaml'

class Pik

  class Config < Hash
      
    def initialize
      @file = File.join(PIK_HOME, 'config.yml')
      super
      if File.exists? @file
        self.update( YAML.load( File.read( @file ) ) )
      end
    end

    def write
      File.open(@file, 'w'){|f| f.puts YAML::dump(Hash[self]) }
    end

  end

end
