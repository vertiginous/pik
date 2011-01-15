module Pik

  class Refresh < Command
        
    it 'Refreshes the pik configuration file.'
    include ConfigFileEditor

    def execute
      puts "** Refreshing the list of installed rubies."
      old_config = @config.rubies.dup
      @config.rubies.clear
      adder = Pik::Add.new([], @config)
      old_config.each do |version,hash|
        adder.add(hash[:path])
      end 
    end

  end

end