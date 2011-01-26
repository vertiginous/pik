module Pik

  class Update < Command
   
    aka :up
    it "updates pik."

    include Installer
    include ScriptFileEditor

    def execute
      puts pik_version
      if up_to_date?
        Log.info "This is the most recent version available."
      else
        Log.info "Updating to #{latest}"
        file = download("#{host}pik-#{latest}.zip")
        clean_update_directory
        extract(update_directory, file)
        @script.copy(update_directory + '*.*', Pik.exe.dirname)
        Log.info "Updating files."
      end
    end

    def update_directory
      @update_directory ||= download_directory + 'pik'
    end

    def clean_update_directory
      FileUtils.rm_rf update_directory
      update_directory.mkpath
    end

    def up_to_date?
      latest == Pik::VERSION
    end

    def latest
      @latest ||= packages.last
    end

    def packages
      @packages ||= index
    end
      
    def index
      uri = URI.parse(host + 'pik.yml')
      YAML.load(uri.read)
    end

    def host
      'http://s3.amazonaws.com/vertiginous.pik/'
    end

  end

end
