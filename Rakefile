require 'rubygems'
require 'rbconfig'

# I couldn't get hoe-isolate plugin to work
# require order problem, perhaps?
require 'isolate/now' 
require 'isolate/lockdown'
require 'hoe'

Hoe.plugin :git

$LOAD_PATH.unshift('lib')
require 'pik'

Hoe.spec('pik') do

  developer('Gordon Thiesfeld', 'gthiesfeld@gmail.com')
  
  self.need_tar = false
  self.readme_file = 'README.rdoc'
  self.post_install_message =<<-PIM

----------------------------------------------------------------------------

*  If you're upgrading from a version <= 0.1.1, you'll want to delete the 
   pik.bat file from all of your ruby versions. Gem uninstall should do the
   trick.
    
*  Install pik to a location that's in your path, but someplace other than 
   your ruby\\bin dir If you're upgrading from a more recent version, 
   pik_install will overwrite the older files as needed.
   
     >path
      PATH=C:\\tools\\;C:\\ruby\\186-p368-mingw32\\bin;C:\\WINDOWS\\system32;C:\\WINDOWS

     >pik_install C:\\tools
  
----------------------------------------------------------------------------  

PIM

end

require 'tasks/package'
require 'tasks/build'
require 'tasks/cucumber'

