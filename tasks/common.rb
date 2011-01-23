module Installer
 include Pik::Installer
 extend self

  def download_and_extract(url, install_root)
    file = download(url)
    extract(install_root, file)
  end

end

file 'tmp/upx307w/upx.exe' do
  url = 'http://upx.sourceforge.net/download/upx307w.zip'
  Installer.download_and_extract(url, Pathname('tmp'))
end

file 'tmp/wix/candle.exe' do
  url = 'http://wix.sourceforge.net/releases/3.5.2430.0/wix35-binaries.zip'
  Installer.download_and_extract(url, Pathname('tmp/wix'))
end

task :package, :needs => 'tmp/wix/candle.exe'

task :build, :needs => 'tmp/upx307w/upx.exe'