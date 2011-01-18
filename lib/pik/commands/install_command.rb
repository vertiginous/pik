require 'pik/contrib/uri_ext'
require 'pik/contrib/unzip'
require 'pik/contrib/progressbar'

module Pik

  class  Install < Command
   
    aka :in
    it "Downloads and installs different ruby versions."
    
    attr_reader :target
    
    def initialize(args=ARGV, config_=nil)
      super
      @download_dir = config.global[:download_dir] || Pik.home + 'downloads'
      @install_root = config.global[:install_dir]  || Pik.home + 'rubies'
      FileUtils.mkdir_p @download_dir.to_s
    end
    
    def execute
      name = @args.shift
      ruby = Implementations[name]
      abort "#{name} not found" unless ruby
      
      puts "** Installing #{ruby[:name]}\n\n"
      
      @target = @install_root + ruby[:name]
      handle_target if @target.exist?
      
      file = download(ruby)

      extract(@target, file)

      add(@target)
    end
    
    def command_options
      super
      sep =<<SEP
  Choices are: ruby, jruby, or ironruby
  
  If no version is specified, the latest version will be installed.
  You can see the full list by running 'pik list known'.

  Examples:

    # install the latest version of JRuby (currently 1.5.6)
    >pik install jruby

    # install the latest 1.8.7 version of MRI Ruby 
    >pik install ruby-1.8.7    

SEP
      options.separator sep
      options.on("--force", "Overwrite existing installation") do |value|
        @force = value
      end 
    end
    
    def handle_target
      if @force
        puts "** Removing #{@target}\n\n"
        FileUtils.rm_rf @target
      else
        msg =  "\nThe directory '#{@target}' already exists.\n"
        msg << "Run:\n\n   'pik install --force [ruby]'\n\n" 
        msg << "if you want to replace it.\n"
        abort msg
      end
    end


    def download(ruby, download_dir=@download_dir)
      target = ruby[:url].split('/').last
      target = "#{ruby[:name]}#{ruby[:extname]}" if  target.include?('?')
      target = download_dir + target
      puts "** Downloading:  #{ruby[:url]} \n   to:  #{target.windows}\n\n"
      URI.download(ruby[:url], target.to_s, {:progress => true, :verbose => true})
      return target
    end
    
    def extract(target, file)
      if Which::SevenZip.exe || Which::SevenZip.exe(Pik.exe.dirname)
        FileUtils.mkdir_p target
        extract_(file, target)
      else
        download_seven_zip
        extract(target, file)
      end  
    end

      def add(target)
        puts
        p = Pik::Add.new([target + 'bin'], @config)
        p.execute
        p.close
      end
    
    def seven_zip(target, file)
      file = Pathname(file)
      seven_zip = Which::SevenZip.exe || Which::SevenZip.exe(Pik.exe.dirname)
      puts "** Extracting:  #{file.windows}\n   to:  #{target}" #if verbose
      system("#{seven_zip} x \"#{file.windows}\" -y -aoa -o\"#{target}\" > NUL")
      puts '   done'
    end
    
    def download_seven_zip
      question = "You need the 7zip utility to extract this file.\n"
      question << "Would you like me to download it? (yes/no)"
      if @hl.agree(question){|answer| answer.default = 'yes' }
        uri  = 'http://downloads.sourceforge.net/sevenzip/7za920.zip'
        file = download(uri)
        Zip.fake_unzip(file.to_s, /\.exe|\.dll$/, PIK_SCRIPT.dirname.to_s)
      else
        raise QuitError
      end
    end
    
    def mv_r(src, dest, options = {})
      if File.directory? src
        d = File.directory?(dest) ? File.join(dest, File.basename(src)) : dest
        if File.directory? d
          Dir.glob(File.join(src, '*')).each do |s|
            mv_r(s, d, options)
          end
        else
          FileUtils.mv(src, dest, options)
        end
      else
        FileUtils.mv(src, dest, options)
      end
    end

    def extract_(file, target, options = {})
      fail unless File.directory?(target)

      # based on filetypes, extract the files
      case file
        # tar.z, tar.gz, tar.bz2 and tar.lzma contains .tar files inside, use bsdtar to
        # extract the files directly to target directory without the need to first
        # extract to a temporary directory as when using 7za.exe
        when /(^.+\.tar)\.z$/, /(^.+\.tar)\.gz$/, /(^.+\.tar)\.bz2$/, /(^.+\.tar)\.lzma$/
          bsd_tar_extract(target, file, options)
        when /(^.+)\.tgz$/
          bsd_tar_extract(target, file, options)
        when /(^.+\.zip$)/, /(^.+\.7z$)/
          seven_zip(target, $1)
        else
          raise "Unknown file extension! (for file #{file})"
      end

      # after extraction, lookup for a folder that contains '-' (version number or datestamp)
      folders_in_target = []
      Dir.chdir(target) { folders_in_target = Dir.glob('*') }

      # the package was created inside another folder
      # exclude folders packagename-X.Y.Z or packagename-DATE
      # move all the folders within that into target directly.
      folders_in_target.each do |folder|
        next unless File.directory?(File.join(target, folder)) && folder =~ /\-/

        # take the folder contents out!, now!
        contents = []
        Dir.chdir(File.join(target, folder)) { contents = Dir.glob('*') }

        contents.each do |c|
          mv_r File.join(target, folder, c), target
        end

        # remove the now empty folder
        FileUtils.rm_rf File.join(target, folder)
      end
    end
    
  end
  
end