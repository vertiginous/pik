module Pik

  class ScriptFile

    attr_accessor :lines

    def initialize(file)
      file = file.to_s
      file += extname unless file =~ /#{extname}$/
      @file = Pathname.new(file)
      @lines = [header]
      if block_given?
        yield self
        write
      end
    end
    
    def path
      @file
    end

    def echo(string='.')
      string = ' ' + string unless string == '.'
      @lines << "ECHO#{string}"
      self
    end

    def to_s
      @lines.join("\n")
    end

    def write
      File.open(@file, 'w+'){|f| f.puts self.to_s }
    end

    def << (cmd)
      @lines <<  cmd
    end

  end

end