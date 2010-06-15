# -*- ruby -*-

require 'rubygems'
require 'rbconfig'
require 'uuid'
require 'hoe'

$LOAD_PATH.unshift('lib')
require 'pik'


EXE_VERSION = {
  'version' => {
    'file_version_number' => "#{Pik::VERSION}.0",
    'comments' => 'The Ruby version manager for Windows',
    'product_name' => 'Pik',
    'file_description' => 'Pik Runner',
    'original_filename' => 'pik_runner.exe'
  }
}


ENV['SPEC_OPTS']= '-O spec/spec.opts'

lib = FileList["lib/**/*.rb"]

file 'tools/pik/pik_runner.exy', :needs => ['tools/pik/pik_runner'] + lib do
  Dir.chdir 'tools/pik' do
    sh('ruby -rexerb/mkexy pik_runner -v')
  end
  exy = YAML.load(File.read('tools/pik/pik_runner.exy'))
  zlib1 = {
    'file' =>  File.join(RbConfig::CONFIG['bindir'], 'zlib1.dll'),
    'type' => 'extension-library'
  }
  exy['file']['zlib1.dll']  = zlib1
  exy['resource']  = EXE_VERSION
   
  File.open('tools/pik/pik_runner.exy', 'w+'){ |f| f.puts YAML.dump(exy) }
end

file 'tools/pik/pik_runner.exe', :needs => ['tools/pik/pik_runner.exy'] do
  Dir.chdir 'tools/pik' do
    sh('ruby -S exerb pik_runner.exy')
    sh('upx -9 pik_runner.exe') unless ENV['QUICK']
  end
end

task :build, :needs => 'tools/pik/pik_runner.exe'

task :install, :needs => :build do
  sh('ruby bin/pik_install C:\\bin')
end

task :clobber_exe do
  rm_rf 'tools/pik/pik_runner.exe'
end

task :clobber_exy, :needs => :clobber_exe do
  rm_rf 'tools/pik/pik_runner.exy'
end

task :rebuild, :needs => [:clobber_exy, :build]
task :reinstall, :needs => [:clobber_exy, :install]

task :package => :rebuild


Hoe.plugin :git

Hoe.spec('pik') do

  developer('Gordon Thiesfeld', 'gthiesfeld@gmail.com')
  
  self.need_tar = false
  self.extra_deps = {'highline' =>  '>= 0.0.0'}
  self.readme_file = 'README.rdoc'
  self.post_install_message =<<-PIM

----------------------------------------------------------------------------

*  If you're upgrading from a version <= 0.1.1, you'll want to delete the pik.bat file
   from all of your ruby versions. Gem uninstall should do the trick.
    
*  Install pik to a location that's in your path, but someplace other than your ruby\\bin dir
   If you're upgrading from a more recent version, pik_install will overwrite the older files as needed.
   
    >path
      PATH=C:\\tools\\;C:\\ruby\\186-p368-mingw32\\bin;C:\\WINDOWS\\system32;C:\\WINDOWS

    >pik_install C:\\tools
  
*  If this is a first-time install, add all the versions of ruby that you want to use with pik

    >pik add
    Adding:  186: ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]
     Located at:  c:/ruby/186-p368-mingw32/bin
    
    >pik add C:\\ruby\\IronRuby-091\\bin
    Adding:  091: IronRuby 0.9.1.0 on .NET 2.0.0.0
     Located at:  C:/ruby/IronRuby-091/bin
    
    >pik add C:\\ruby\\jruby-1.4.0RC1\\bin
    Adding:  140: jruby 1.4.0RC1 (ruby 1.8.7 patchlevel 174) (2009-09-30 80c263b) (Java HotSpot(TM) Client VM 1.6.0_14) [x86-java]
     Located at:  C:/ruby/jruby-1.4.0RC1/bin
     

----------------------------------------------------------------------------  

PIM

end

require 'cucumber'
require 'cucumber/rake/task'

@dir = Pathname(File.dirname(__FILE__)) 
@test_versions = {
  'JRuby'     => ['1.5.1'],
  'IronRuby'  => ['0.9.2'],
  'Ruby'      => [
    '1.9.1-p378-1',
    '1.8.6-p398-2',
    '1.8.7-p249-1'
  ]
}


Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features  -f html -o ../pik_cucumber.html -f progress"
end

task :guid do
  puts
  puts UUID.new.generate.upcase
end

directory 'pkg'

@package = 'pik'

msi_file = "pkg/#{@package}-#{Pik::VERSION}.msi"
file msi_file, :needs => 'tools/pik/pik_runner.exe'

task :installer, :needs => [msi_file, :light]

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
# vim: syntax=Ruby

