module Pik

  module VersionPattern
    
    extend self

    def parse(name) # contributed by Shane Emmons
      case name
      when /^\[(.+)\](.+)\[(.+)\]$/
        [ $1 + $2 + $3, $1 + $2, $2 + $3, $2 ]
      when /^\[(.+)\](.+)$/
        [ $1 + $2, $2 ]
      when /^(.+)\[(.+)\]$/
        [ $1, $1 + $2 ]
      else
        [ name ]
      end
    end
    
    def full(name)
      name.gsub(/[\[\]]/,'')
    end

  end

end