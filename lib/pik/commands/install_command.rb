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
      @download_dir = config.global[:download_dir] || PIK_HOME + 'downloads'
      @install_root = config.global[:install_dir]  || PIK_BATCH.dirname + 'pik'
      FileUtils.mkdir_p @download_dir.to_s
    end
    
    def execute
      implementation  = Implementations[@args.shift]
      @target, package = implementation.find(*@args)
      @target          = @install_root + "#{implementation.name}-#{@target.gsub('.','')}"
      file            = download(package)
      extract(@target, file)
      # add( Pathname(target) + 'bin' ) if implementation.add?
      implementation.after_install(self)
    end
    
    def command_options
      super
      sep =<<SEP
  Choices are: ruby, jruby, or ironruby
  
  If no version is specified, the latest version will be installed.
  Download and install locations can be configured with 'pik config'.
  
  Examples:

    # install the latest version of JRuby (currently 1.4.0RC1)
    >pik install jruby

    # install the latest 1.8 version of MinGW Ruby 
    >pik install ruby 1.8    

SEP
      options.separator sep  
    end
    
    def download(package, download_dir=@download_dir)   
      target = download_dir + package. split('/').last
      puts "** Downloading:  #{package} \n   to:  #{target.windows}\n\n"
      URI.download(package, target.to_s, {:progress => true})
      puts
      return target
    end
    
    def extract(target, file)
      if Which::SevenZip.exe
        FileUtils.mkdir_p target
        extract_(file, target)
      else
        download_seven_zip
        extract(target, file)
      end  
    end
    
    # def add(path)
    #   puts
    #   p = Pik::Add.new([path], config)
    #   p.execute
    #   p.close
    # end
    
    def seven_zip(target, file)
      file = Pathname(file)
      seven_zip = Which::SevenZip.exe.basename 
      puts "** Extracting:  #{file.windows}\n   to:  #{target}" #if verbose
      system("#{seven_zip} x -y -o\"#{target}\" \"#{file.windows}\" > NUL")
      puts 'done'
    end
    
    def download_seven_zip
      question = "You need the 7zip utility to extract this file.\n"
      question << "Would you like me to download it? (yes/no)"
      if @hl.agree(question){|answer| answer.default = 'yes' }
        uri  = 'http://downloads.sourceforge.net/sevenzip/7za465.zip'
        file = download(uri)
        Zip.fake_unzip(file.to_s, /\.exe|\.dll$/, PIK_BATCH.dirname.to_s)
      else
        raise QuitError
      end
    end
    
    def extract_(file, target, options = {})
      fail unless File.directory?(target)
      
      # create a temporary folder used to extract files there
      tmpdir = File.expand_path(File.join(Dir.tmpdir, "extract_sandbox_#{$$}"))
      FileUtils.mkpath(tmpdir) unless File.exist?(tmpdir)
    
      # based on filetypes, extract the intermediate file into the temporary folder
      case file
        # tar.z, tar.gz and tar.bz2 contains .tar files inside, extract into 
        # temp first
        when /(^.+\.tar)\.z$/, /(^.+\.tar)\.gz$/, /(^.+\.tar)\.bz2$/
          seven_zip tmpdir, file
          seven_zip target, File.join(tmpdir, File.basename($1))
        when /(^.+)\.tgz$/
          seven_zip tmpdir, file
          seven_zip target, File.join(tmpdir, "#{File.basename($1)}.tar")
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
          #puts "** Moving out #{c} from #{folder} and drop into #{target}" if Rake.application.options.trace
          FileUtils.mv File.join(target, folder, c), target, :force => true
        end
        
        # remove the now empty folder
        # puts "** Removing #{folder}" if Rake.application.options.trace
        FileUtils.rm_rf File.join(target, folder)
      end
    
      # remove the temporary directory
      # puts "** Removing #{tmpdir}" if Rake.application.options.trace
      FileUtils.rm_rf tmpdir
    end
    
  end
  
end