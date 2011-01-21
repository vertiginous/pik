require 'yaml'
require 'forwardable'

module Pik

  class ConfigFile
    extend Forwardable
    attr_reader :global, :rubies, :options
      
    def initialize(file = File.join(Pik.home, 'config.yml'))
      @file = file
      @rubies  = {}
      @global  = {}
      @options = {}
      if File.exists? @file
        contents = File.read( @file )
        unless contents.empty?
          documents = YAML.load_stream( contents )  
          @rubies.update( documents[0] )
          @global.update( documents[1] ) if documents[1]
        end
      end
    end

    def_delegators :@rubies, :[], :[]=, :clear, :sort, :find, :keys, 
      :delete, :each, :include?, :select

    def match(string)
      find{|pattern, ver| VersionPattern.parse(pattern).include? string }
    end

    def write
      File.open(@file, 'w')do |f| 
        f.puts YAML.dump(@rubies), YAML.dump(@global) 
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