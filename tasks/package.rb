require 'uuid'
task :package => [:build, 'installer:package', "pkg/pik-#{Pik::VERSION}.zip" ]

file "pkg/pik-#{Pik::VERSION}.zip" => "pkg/pik-#{Pik::VERSION}/tools" do
  chdir("pkg/pik-#{Pik::VERSION}/tools") do
    sh %{zip pik-#{Pik::VERSION}.zip pik* }
    mv "pik-#{Pik::VERSION}.zip", '../..'
  end
end

### installer

require 'nokogiri'

namespace :installer do

  def version_string
    @version.gsub(".","")
  end

  directory 'pkg'
  @package  = 'pik'
  @wix_file = "lib/installer/#{@package}.wxs"
  @wxs      = Nokogiri::XML(File.open(@wix_file))
  @product  = @wxs.at_css("Product")

  msi_file  = "pkg/#{@package}-#{Pik::VERSION}.msi"

  file msi_file, :needs => 'tools/pik_runner.exe'

  desc "packages the msi installer"
  task :package, :needs => [msi_file, :light]

  task :candle do
    chdir 'lib/installer/' do
      cmd = "../../tmp/wix/candle.exe -nologo"
      wxs_files = ["MyInstallDirDialog.wxs",'WixUI_MyInstallDir.wxs' , "#{@package}.wxs"].join(' ')
      sh("#{cmd} #{wxs_files}")
    end
  end

  task :light, :needs => :candle do
    chdir 'lib/installer/' do
      cmd = "../../tmp/wix/light.exe -nologo "
      wixobj_files = ["MyInstallDirDialog.wixobj", 'WixUI_MyInstallDir.wixobj', "#{@package}.wixobj"].join(' ')
      sh("#{cmd} -ext WixUtilExtension -ext WixUIExtension #{wixobj_files} -o ../../#{msi_file}")
    end
  end

  desc "updates wix xml file to prep for a new version"
  task :upgrade do
    @product["Version"] = Pik::VERSION
    
    upgrade_max = @product.at_css("UpgradeVersion[Property = 'OLDAPPFOUND']")
    upgrade_max["Maximum"] = Pik::VERSION

    upgrade_min = @product.at_css("UpgradeVersion[Property = 'NEWAPPFOUND']")
    upgrade_min["Minimum"] = Pik::VERSION

    @product["Id"] = UUID.new.generate
    File.open(@wix_file, 'w+'){|f| f.puts @wxs }
  end

end