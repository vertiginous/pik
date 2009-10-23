module Pik
  
  def self.print_error(error)
    puts "\nThere was an error."
    puts " Error: #{error.message}\n\n"
    puts error.backtrace.map{|m| "  in: #{m}" }
    puts
  end
  
end