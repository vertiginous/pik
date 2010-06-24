module Pik

  module ConfigFileEditor

    def initialize(args=ARGV, config_=nil, log=Log.new)
      super
      editors << @config
    end
  
  end
  
end