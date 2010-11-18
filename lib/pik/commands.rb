module Pik

  module Commands
  
    def self.clear
      commands.clear
    end
  
    def self.add(command)
      commands << command
    end
  
    def self.find(cmds, config)
      cmds = (cmds & list)
      names[cmds.first.to_sym] unless cmds.size.zero?
    end

    def self.list
      @list ||= names.keys.map{|name| name.to_s }.flatten
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

    def self.names
      return @names if @names
      @names = {}
      @commands.each{|cmd| cmd.names.each{|name|  @names[name] = cmd }}
      @names
    end
  
    def self.deprecate(command)
      deprecated.update command
    end

    def self.deprecated
      @deprecated ||= {}
    end
      
  end
  
end