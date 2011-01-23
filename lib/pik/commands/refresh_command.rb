module Pik

  class Refresh < Command
        
    it 'Refreshes the pik configuration file.'
    include ConfigFileEditor

    def execute
      Log.info "Refreshing the list of installed rubies."

      old_config = config.rubies.dup
      config.rubies.clear

      
      old_config.each do |version,hash|
        add_cmd.add(hash[:path])
      end 
    end

    def add_cmd
      @add_cmd ||= Pik::Add.new([], config)
    end

  end

end