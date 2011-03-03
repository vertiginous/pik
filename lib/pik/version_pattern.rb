module Pik

  module VersionPattern
    
    extend self

    def parse(str) # contributed by Felipe Doria
      optional = str.match /\[(.+?)\]/
      if optional
        with    = optional.pre_match + optional[1] + optional.post_match
        without = optional.pre_match + optional.post_match
        parse(with) | parse(without)
      else
        [str]
      end
    end

    def full(name)
      name.gsub(/[\[\]]/,'')
    end

  end

end