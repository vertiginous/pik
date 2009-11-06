require 'ostruct'
require 'win32console'
require 'term/ansicolor'

module Pik

  class  Checkup < Command
    include Term::ANSIColor
    
    attr_reader :output
    
    HOME    = OpenStruct.new(
        :pass => 'The HOME environment varible is set.',
        :fail => 'The HOME environment varible is not set.'
      )
    RUBYOPT = OpenStruct.new(
        :pass => "The RUBYOPT environment varible is empty.",
        :fail => "The RUBYOPT environment varible contains '-rubygems'"
      )
    PATH    = OpenStruct.new(
        :pass => "There is only one version of Ruby in the system PATH.",
        :fail => "There is more than one version of Ruby in the system PATH."        
      )
    PATHEXT = OpenStruct.new(
        :pass => 'The .rb and .rbw extension are in the PATHEXT environment variable.',
        :fail => 'The .rb and .rbw extension are not in the PATHEXT environment variable.'
      )
    
    aka :cu
    it "Checks your environment for current Ruby best practices."
    
    def execute
      checks = [:home, :rubyopt, :path, :pathext].map{|item| check(item) }
      puts
      checks.each_with_index{|check, i| puts "\n#{i+1})  #{check}" }
    end

    def check(item)
      send(item) ? pass(item) : fail(item)
    end

    def rubyopt
      syst_opt = WindowsEnv.user['rubyopt'] || '' 
      user_opt = WindowsEnv.system['rubyopt'] || ''
      !(user_opt + syst_opt).downcase.include?('-rubygems')
    end

    def home
      WindowsEnv.user['home']
    end

    def path
      user_path = WindowsEnv.user['path']    || '' 
      syst_path = WindowsEnv.system['path']  || ''
      full_path = [user_path + syst_path].join(';')
      dirs = Which::Ruby.find_all( full_path )
      dirs.size == 1
    end

    def pathext
      p_ext = WindowsEnv.system['pathext'].downcase
      p_ext.include?('.rb') && p_ext.include?('.rbw')
    end

    def pass(test)
      print green, '.', reset
      $stdout.flush
      [green, text(test).pass, reset]
    end

    def fail(test)
      print red, 'F', reset
      $stdout.flush
      [red, text(test).fail, reset]
    end
    
    def text(test)
      self.class.const_get(test.to_s.upcase)
    end
  
  end

end