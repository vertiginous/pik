Feature: install command
  In order to keep up to date with multiple ruby implementations
  A developer
  Wants a command line tool 
  So that he can download and install them

  Scenario: install from the intarwebs
     When I run "pik rm 191 -f -q" 
    When I run "pik install ruby 1.9.1"
    Then I should see "** Downloading:  http://rubyforge.org/frs/download.php/71082/ruby-1.9.1-p378-i386-mingw32-1.7z"
    And I should see "  to:  C:\temp\path with spaces\downloads\ruby-1.9.1-p378-i386-mingw32-1.7z"
    And I should see "** Extracting:  C:\temp\path with spaces\downloads\ruby-1.9.1-p378-i386-mingw32-1.7z"
    And I should see "** Adding:  191: ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32]"


  Scenario: install IronRuby
    When I run "pik rm iron 92 -f -q" 
    When I run "pik in ironruby 0.9.2"
    Then I should see "** Downloading:  http://rubyforge.org/frs/download.php/66606/ironruby-0.9.2.zip"
    And I should see "   to:  C:\temp\path with spaces\downloads\ironruby-0.9.2.zip"
    And I should see "** Extracting:  C:\temp\path with spaces\downloads\ironruby-0.9.2.zip"
    And I should see "** Adding:  092: IronRuby 0.9.2.0 on .NET 2.0.0.0"
    And I should see " Located at:  C:\temp\path with spaces\IronRuby-092\bin"

  Scenario: install Ruby 1.8.7
    When I run "pik rm 187-test -f -q"
    When I run "pik rm 187 p-f -q"
    When I run "pik in ruby 1.8"
    Then I should see "** Downloading:  http://rubyforge.org/frs/download.php/71081/ruby-1.8.7-p249-i386-mingw32-1.7z"
    And I should see "   to:  C:\temp\path with spaces\downloads\ruby-1.8.7-p249-i386-mingw32-1.7z"
    And I should see "** Extracting:  C:\temp\path with spaces\downloads\ruby-1.8.7-p249-i386-mingw32-1.7z"
    And I should see "** Adding:  187: ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]"
    And I should see " Located at:  C:\temp\path with spaces\Ruby-187-p249-1\bin"
    