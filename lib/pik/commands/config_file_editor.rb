module Pik

  module ConfigFileEditor

    def initialize(args=ARGV,config_=nil)
      super
      editors << config
    end
  
  end
  
end