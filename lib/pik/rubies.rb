
module Pik
  
  module Packages

    extend self

    def [](key)
      packages[key]
    end

    def packages
      @packages ||= YAML.load(read('http://vert.igino.us/pik/packages.yml'))
    end

    def read(package)
      uri = URI.parse(package)
      uri.read rescue ''
    end

  end

  module Rubies
    extend VersionPattern
    extend self

    def rubies 
      @rubies ||= Packages['rubies']
    end

    def list
      h = Hash.new{|h,k| h[k] = [] }
      rubies.each{|name,data| h[data[:implementation]] << name  }
      h
    end
    
    def [](key)
      found = all_rubies.find{|names, data| names.include? key }
      found.last if found
    end

    def all_rubies
      return @all_rubies if @all_rubies
      @all_rubies = {}
      rubies.each do |name, data| 
        names = parse(name)
        @all_rubies[names] = data.merge!(:name => full(name), :pattern => name)
      end
      @all_rubies  
    end

  end
  
end