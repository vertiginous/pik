class Pik

  class Checkup
  
    def initialize(text)
      @text   = text
      # pp @text
      @output = ["Checkup results:"]
    end

    def check
      home
      rubyopt
      path
      pathext

      puts
      puts

      self
    end

    def to_s
      ERB.new(@output.join("\n\n")).result
    end

    def rubyopt
      unless WindowsEnv.user['rubyopt'].empty? && WindowsEnv.system['rubyopt'].empty?
        fail('rubyopt')        
      else
        pass('rubyopt')
      end
    end

    def home
      if WindowsEnv.user['home'].empty?
        fail('home')        
      else
        pass('home')
      end
    end

    def path
      dirs = (WindowsEnv.user['path'] + WindowsEnv.system['path']).split(';')
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
      @output << @text[test][:pass]
    end

    def fail(test)
      print 'F'
      @output << @text[test][:fail]
    end

  end

end
