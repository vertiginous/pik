module Pik

  module ConfigFileEditor

    def initialize(args=ARGV,config=nil)
      super
      editors << @config
    end
  
  end
  
end