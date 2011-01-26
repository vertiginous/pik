module Pik

  class Package < Command

    it "Downloads and installs packages."
    include Installer

    def execute
      if @args[1] == "install"
        case @args.first.downcase
        when "devkit"
          devkit
        when "7zip"
          sevenzip
        when "sqlite"
          sqlite
        when 'ansicon'
          ansicon
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

    def devkit
      check_7zip
      devkit_root = install_root + 'devkit'
      file = download(url('devkit'))
      extract(devkit_root, file)
      write_devkit_config(devkit_root)
      FileUtils.chdir(devkit_root) do
        Log.info "Running the devkit installer."
        sh("ruby dk.rb install --force")
      end
    end

    def ansicon
      check_7zip
      file = download(url('ansicon'))
      extract(install_root, file, {:recurse => ansicon_arch, :extract => :flat})
      sh(install_root + "ansicon.exe", "-i")
      msg =  "Ansicon is installed for new shells.  Run 'ansicon -p'\n"
      msg << "      to install it for this shell"
      Log.info msg
    end

    def sqlite
      check_7zip
      file = download(url('sqlite'))
      extract(install_root, file)
    end

    def sevenzip
      file = download(url('7zip'))
      Log.info "Extracting:  #{file.windows}\n      to:  #{install_root}"
      Zip.fake_unzip(file.to_s, /\.exe|\.dll$/, install_root.to_s)
    end

    def url(package)
      Packages[package][:url]
    end

    def command_options
      super
      sep =<<-SEP
  sqlite:  'pik package sqlite install'
  7zip:    'pik package 7zip install'
  ansicon: 'pik package ansicon install'
  devkit:  'pik package devkit install' # Installed to mingw versions only.

In some cases, The package command assumes that pik is 
installed on your path.  If it is not, you'll want to use 
the path parameter so pik can install files to a location
that is in your path.

  pik package install sqlite C:\\bin

In the case of the devkit, it is STRONGLY recommended
that you don't install to a path with spaces.

If you have an idea for another package, submit a
feature request at https://github.com/vertiginous/pik/issues

SEP
      options.separator sep
    end

    def write_devkit_config(dir)
      Log.info "Writing #{dir + "config.yml"}"
      File.open(dir + "config.yml",'w') do |f|
        f.puts YAML.dump(mingw_ruby_dirs)
      end
    end

    def mingw_ruby_dirs
      config.select{|n, cfg| mingw?(cfg[:version]) }.
        map{|k,i| i[:path].dirname.to_ruby }
    end

    def mingw?(version)
      Pik::VersionParser.parse(version).platform =~ /mingw/
    end

    #determines x86 or x64 architecture
    def ansicon_arch
      key = "SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment"
      if Reg.new.hklm(key, 'PROCESSOR_ARCHITECTURE') =~ /64/
        'x64'
      else
        'x86'
      end
    end

  end

end