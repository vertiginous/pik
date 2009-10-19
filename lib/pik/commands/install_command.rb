require 'pik/contrib/uri_ext'
require 'pik/contrib/unzip'
require 'pik/contrib/progressbar'

module Pik

  class  Install < Command
  
    aka :in
    it "Downloads and installs different ruby versions."
    
    def versions
       {
        'ruby' => {
          '1.8.6-p383' =>
          'http://rubyforge.org/frs/download.php/62267/ruby-1.8.6-p383-i386-mingw32.7z',
          '1.9.1-p243' =>
          'http://rubyforge.org/frs/download.php/62269/ruby-1.9.1-p243-i386-mingw32.7z'
          },
        'ironruby' => {
          '0.9.1' =>
          'http://rubyforge.org/frs/download.php/64504/ironruby-0.9.1.zip',
          '0.9.0' =>
          'http://rubyforge.org/frs/download.php/61382/ironruby-0.9.0.zip'
        },
        'jruby' => {
          '1.4.0RC1' =>
          'http://dist.codehaus.org/jruby/1.4.0RC1/jruby-bin-1.4.0RC1.zip'
        }
      }
    end
    
    def execute
      target = ''
      @download_dir = config.global[:download_dir] || PIK_HOME + 'downloads'
      FileUtils.mkdir_p @download_dir.to_s
      version = @args.shift
      if versions[version]
        target += version
        version = versions[version]
        @args.each{ |i| version = version.select{|k,v| k =~ Regexp.new(Regexp.escape(i)) } }
        t, version = most_recent(version)
        target += "_#{t}"
      elsif URI.parse(version.to_s) === URI::HTTP
        version = URI.parse(version.to_s)
        target  = @args.shift
      else
        raise VersionUnknown
      end
      install_root = config.global[:install_dir] || PIK_BATCH.dirname + 'pik'
      target =  install_root + target.gsub('.','')
      FileUtils.mkdir_p target
      file = download(version)
      extract(target, file)
      add( Pathname(target) + 'bin' )
    rescue VersionUnknown
      puts 'unknown'   
    end
    
    def command_options
      super
      sep =<<SEP
  
  Choices are: ruby, jruby, or ironruby
  
  If no version is specified, the latest version will be installed.
  
  Examples:

    # install the latest version of JRuby (currently 1.4.0RC1)
    >pik install jruby

    # install the latest 1.8 version of MinGW Ruby 
    >pik install ruby 1.8    

SEP
      options.separator sep  
    end
    
    def most_recent(version)
      version.sort.last
    end
    
    def download(version, download_dir=@download_dir)   
      target = download_dir + version.split('/').last
      puts "** Downloading:  #{version}\n   to:  #{target.windows}\n\n"
      URI.download(version,target.to_s, {:progress => true})
      puts
      return target
    end
    
    def extract(target, file)
      if Which::SevenZip.exe
        extract_(file, target)
      else
        file = download_seven_zip
        extract(target, file)
      end  
    end
    
    def add(path)
      puts
      p = Pik::Add.new([path], config)
      p.execute
      p.close
    end
    
    def seven_zip(target, file)
      file = Pathname(file)
      seven_zip = Which::SevenZip.exe.basename 
      puts "** Extracting:  #{file.windows}\n   to:  #{target}" #if verbose
      system("#{seven_zip} x -y -o\"#{target}\" \"#{file.windows}\" > NUL")
      puts 'done'
    end
    
    def download_seven_zip
      question = "You need the 7zip utility to extract this file.\n"
      question << "Would you like me to download it? [Yn]"
      if @hl.agree question
        uri    = 'http://downloads.sourceforge.net/sevenzip/7za465.zip'
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