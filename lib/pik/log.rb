module Pik
  
  class Log
    include Term::ANSIColor

    def error(message, backtrace=[])
      error = red("error") if Pik::colored?
      puts "#{error}: #{message}\n\n"
      unless backtrace.empty?
        puts backtrace.map{|m| "  in: #{m}" } 
        puts
      end
    end

    def info(message)
      info = green("info") if Pik::colored?
      puts "#{info}: #{message}\n\n"
    end

  end

end