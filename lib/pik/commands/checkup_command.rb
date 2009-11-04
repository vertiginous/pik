module Pik

  class  Checkup < Command  
    
    aka :cu
    it "Checks your environment for current Ruby best practices."
    
    def execute
      home
      rubyopt
      path
      pathext
    end

    def to_s
      ERB.new(@output.join("\n\n")).result
    end

    def rubyopt
      unless WindowsEnv.user['rubyopt'].nil? && WindowsEnv.system['rubyopt'].nil?
        fail('rubyopt')        
      else
        pass('rubyopt')
      end
    end

    def home
      if WindowsEnv.user['home'].nil?
        fail('home')        
      else
        pass('home')
      end
    end

    def path
      user_path = WindowsEnv.user['path']    || ''
      syst_path = WindowsEnv.system['path']  || ''
      dirs = (user_path + syst_path).split(';')
      dirs = dirs.select{|dir| File.exist?( File.join(dir,'ruby.exe') ) }
      unless dirs.size == 1
        fail('path')        
      else
        pass('path')
      end
    end

    def pathext
      p_ext = WindowsEnv.system['pathext'].downcase
      unless p_ext.include?('.rb') && p_ext.include?('.rbw')
        fail('pathext')        
      else
        pass('pathext')
      end
    end

    def pass(test)
      print '.'
      $stdout.flush
      # @output << @text[test][:pass]
    end

    def fail(test)
      print 'F'
      $stdout.flush
      # @output << @text[test][:fail]
    end

  end
  
end