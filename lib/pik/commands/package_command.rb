module Pik

  class Package < Command

    it "Downloads and installs packages."
    include Installer

    def execute
      if @args[1] == "install"
        case @args.first.downcase
        # when "devkit"
        #   devkit
        when "7zip"
          sevenzip
        when "sqlite"
          sqlite
        else
          help
        end
      else
        help
      end
    end

    def install_root
      @install_root ||= optional_dir || Pik.exe.dirname
    end

    def optional_dir
      @args[2] && Pathname(@args[2]).exist? ? Pathname(@args[2]) : nil
    end

    def help
      abort "'#{@args.first}' is an unknown package."
    end

    # def devkit
    #   file = download(url('devkit'))
    #   extract(install_root + 'devkit', file)
    # end

    def sqlite
      file = download(url('sqlite'))
      extract(install_root, file)
    end

    def sevenzip
      file = download(url('7zip'))
      Zip.fake_unzip(file.to_s, /\.exe|\.dll$/, install_root.to_s)
    end

    def url(package)
      Packages[package][:url]
    end

    def command_options
      super
      sep =<<-SEP
  sqlite: 'pik package sqlite install'
  7zip:   'pik package 7zip install'

If you have an idea for another package, submit a
feature request at https://github.com/vertiginous/pik/issues

SEP
      options.separator sep
    end

    # module Devkit

    #   def write_config
    #     File.open("config.yml",'w') do |f|
    #       f.puts YAML.dump(mingw_ruby_dirs)
    #     end
    #   end

    #   def mingw_ruby_dirs
    #     config.select{|n, cfg| mingw?(cfg[:version]) }.
    #       map{|k,i| i[:path].dirname.to_ruby }
    #   end

    #   def mingw?(version)
    #     Pik::VersionParser.parse(version).platform =~ /mingw/
    #   end

    # end

  end

end