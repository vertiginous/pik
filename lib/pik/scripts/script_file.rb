module Pik

  class ScriptFile

    attr_accessor :file_data, :file_name, :ruby_dir

    def initialize(file) #, mode=:new)
      file = file.to_s
      file += extname unless file =~ /#{extname}$/
      @file = Pathname.new(file)
      @file_data = [header]
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
      @file_data << "ECHO#{string}"
      self
    end

    def remove_line(re)
      @file_data.reject!{ |i| i =~ re }
    end

    def to_s
      @file_data.join("\n")
    end

    def write
      File.open(@file, 'w+'){|f| f.puts self.to_s }
    end

    def << (cmd)
      @file_data <<  cmd
    end

  end

end