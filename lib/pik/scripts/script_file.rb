module Pik

  class ScriptFile

    attr_accessor :lines, :file_name

    def initialize(file)
      file = file.to_s
      file += extname unless file =~ /#{extname}$/
      @file = Pathname.new(file)
      @lines = [header]
      yield self if block_given?
    end
    
    def path
      @file
    end

    def extname
      raise
    end

    def echo(string='.')
      string = ' ' + string unless string == '.'
      @lines << "ECHO#{string}"
      self
    end

    def remove_line(re)
      @lines.reject!{ |i| i =~ re }
    end

    def []=(variable,value)
      set(variable => value)
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