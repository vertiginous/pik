require 'uuid'
require 'rake/packagetask'

task :package => [:rebuild, 'installer:package']

Rake::PackageTask.new('pik-update', Pik::VERSION) do |p|
  p.need_zip = true
  p.package_files.include("tools/pik_runner.exe",'tools/pik.bat','tools/pik.ps1')
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

  task :build_env do
   ENV['PATH'] = "#{ENV['ProgramFiles(x86)']}\\Windows Installer XML v3.5\\bin;#{ENV['PATH']}"
  end

  task :candle, :needs => [:build_env] do
    chdir 'lib/installer/' do
      wxs_files = ["MyInstallDirDialog.wxs",'WixUI_MyInstallDir.wxs' , "#{@package}.wxs"].join(' ')
      # wxs_files = ["#{@package}.wxs"].join(' ')
      sh("candle -nologo #{wxs_files}")
    end
  end

  task :light, :needs => :candle do
    chdir 'lib/installer/' do
      wixobj_files = ["MyInstallDirDialog.wixobj", 'WixUI_MyInstallDir.wixobj', "#{@package}.wixobj"].join(' ')
      # wixobj_files = ["#{@package}.wixobj"].join(' ')
      sh("light -nologo -ext WixUtilExtension -ext WixUIExtension #{wixobj_files} -o ../../#{msi_file}")
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