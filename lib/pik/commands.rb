module Pik

  module Commands
  
    def self.clear
      commands.clear
    end
  
    def self.add(command)
      commands << command
    end
    
    def self.find(command)
      commands.find{ |cmd| cmd.names.include?(command.to_sym) }
    end
  
    def self.list
      commands.map{|c| c.names }.flatten
    end
    
    def self.description
      commands.sort_by{|c| c.name }.map do |cmd|
        "  %-15s %s" % [cmd.names.join('|'), cmd.summary]
      end.join("\n") + 
      "\n\nFor help on a particular command, use 'pik help COMMAND'."
    end
  
    def self.commands
      @commands ||= []
    end
  
  
  end
  
end