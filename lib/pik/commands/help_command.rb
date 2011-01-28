module Pik

  class  Help < Command
    
    it 'Displays help information.'
    
    def execute
      puts options if @args.empty? && !version
      
      @args.each do |a|
        @msg = case a.to_sym
        when *Commands.list
          Commands.find(a).description
        when :commands
          Commands.description
        when :default
          msg =  "Error: You must define a default ruby first.\n\nRun:\n\n"
          msg << "   pik use [ruby] --default\n\n"
          abort msg
        else
          "There is no command '#{a}' \n" +
          Pik::Help.description
        end
        
        puts "\n" + @msg + "\n"
      end

    end
   
    def command_options
      options.program_name = "pik command"
      sep = <<SEP

To get help with a command

  pik help (command)

To list all commands and descriptions:

  pik help commands

SEP
      options.separator sep
    end
   
  end
    
end