module Pik
  
  class Log
    include Term::ANSIColor

    def error(message, backtrace=[])
      error = red("error")
      puts "#{error}: #{message}\n\n"
      puts backtrace.map{|m| "  in: #{m}" }
      puts unless backtrace.empty?
    end

    def info(message)
      info = green("info")
      puts "#{info}: #{message}\n\n"
    end

  end

end