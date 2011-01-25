require 'pik/contrib/uri_ext'
require 'pik/contrib/unzip'
require 'pik/contrib/progressbar'
require 'pik/config_file'

module Pik
  
  module Installer

    def config
      @config ||= ConfigFile.new
    end

    def download_directory
      @download_dir ||= Pathname(
                config.global.fetch(:download_dir, Pik.home + 'downloads')
        )
    end

    def download(package, opts={})
      download_directory.mkpath
      
      target = download_directory + opts.fetch(:filename, filename(package))
      
      Log.info  "Downloading:  #{package} \n      to:  #{target.windows}"
      URI.download(package, target.to_s, {:progress => true, :verbose => true})
      return target
    end

    def filename(package)
      package.split('/').last
    end  

    def check_7zip
      unless seven_zip
        msg =  "You need the 7zip utility to extract this file.\n"
        msg << "       Run 'pik package 7zip install'"
        Log.error msg
        exit 1
      end  
    end
    
    def seven_zip
      @seven_zip ||= Which::SevenZip.exe || Which::SevenZip.exe(Pik.exe.dirname)
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

    def extract(target, file)
      target.mkpath
      # based on filetypes, extract the files
      Log.info "Extracting:  #{file.windows}\n      to:  #{target}" #if verbose
      case file.to_s
      when /(^.+\.zip$)/, /(^.+\.7z$)/, /(^.+\.exe$)/
        file = Pathname($1)
        cmd = " \"#{seven_zip}\" x \"#{file.windows}\" -y -o\"#{target}\" > NUL"
        Log.debug cmd
        system(cmd)
      else
        raise "Unknown file extension! (for file #{file})"
      end

      # after extraction, look for a folder that contains '-' (version number or datestamp)
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

      puts '      Extraction complete.'
    end

  end

end
