
module Pik

  class  Info < Command
  
    it "Displays information about the current ruby version."
  
    def execute
      puts info      
    end
    
    def info
      ruby = Which::Ruby.exe
      ruby_version = find_config_from_path(ruby.dirname)
      current = config[ruby_version]
      gem_home = current[:gem_home] || actual_gem_home
      ruby_version = Pik::VersionParser.parse(ruby_version)
      
      return info =<<INFO
#{pik_version}

ruby:
interpreter:  "#{ruby_version.interpreter}"
version:      "#{ruby_version.version}"
date:         "#{ruby_version.date}"
platform:     "#{ruby_version.platform}"
patchlevel:   "#{ruby_version.patchlevel}"
full_version: "#{ruby_version.full_version}"

homes:
gem:          "#{gem_home}"
ruby:         "#{ruby.dirname.dirname}"

binaries:
ruby:         "#{ruby}"
irb:          "#{Which::Irb.exe}"
gem:          "#{Which::Gem.exe}"
rake:         "#{Which::Rake.exe}"

environment:
GEM_HOME:     "#{ENV['GEM_HOME']}"
HOME:         "#{ENV['HOME']}"
IRBRC:        "#{ENV['IRBRC']}"
INFO
    end

  end
  
end