require 'yaml'
require 'forwardable'

module Pik

  class ConfigFile
    extend Forwardable
    attr_reader :global
      
    def initialize
      @file = File.join(Pik.home, 'config.yml')
      @config = {}
      @global = {}
      super
      if File.exists? @file
        contents = File.read( @file )
        unless contents.empty?
          documents = YAML.load_stream( contents )  
          @config.update( documents[0] )
          @global.update( documents[1] ) if documents[1]
        end
      end
    end

    def_delegators :@config, :[], :[]=, :clear, :sort, :find, :keys

    def write
      File.open(@file, 'w')do |f| 
        f.puts YAML.dump(@config), YAML.dump(@global) 
      end
    end

  end

end

class Hash
  # Replacing the to_yaml function so it'll serialize hashes sorted (by their keys)
  #
  # Original function is in /usr/lib/ruby/1.8/yaml/rubytypes.rb
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        sort_by{|s| s[0].to_s}.each do |k, v|   # <-- here's my addition (the 'sort')
          map.add( k, v )
        end
      end
    end
  end
end