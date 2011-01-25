module Pik
  
  module Log
    extend self

    def error(message, backtrace=[])
      puts "ERROR: #{message}\n\n"
      unless backtrace.empty?
        puts backtrace.map{|m| "  in: #{m}" } 
        puts
      end
    end

    def info(message)
      puts "INFO: #{message}\n\n"
    end

    def debug(message)
      puts "DEBUG: #{message}\n\n" if level == :debug
    end

    def level
      @level ||= :error
    end

    def level=(sym)
      @level = sym
    end

  end

end