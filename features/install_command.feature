Feature: install command
  In order to keep up to date with multiple ruby implementations
  A developer
  Wants a command line tool 
  So that he can download and install them

  Scenario: install from the intarwebs
    When I run "pik install ruby"
    Then I should see "** Downloading:  http://rubyforge.org/frs/download.php/62269/ruby-1.9.1-p243-i386-mingw32.7z"
    And I should see "   to:  C:\temp\path with spaces\downloads"
    And I should see "** Extracting:  C:\temp\path with spaces\downloads"
    And I should see "** Adding:  191: ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]"


  Scenario: install IronRuby
    When I run "pik in ironruby"
    Then I should see "** Downloading:  http://rubyforge.org/frs/download.php/64504/ironruby-0.9.1.zip"
    And I should see "   to:  C:\temp\path with spaces\downloads\ironruby-0.9.1.zip"
    And I should see "** Extracting:  C:\temp\path with spaces\downloads\ironruby-0.9.1.zip"
    And I should see "** Adding:  091: IronRuby 0.9.1.0 on .NET 2.0.0.0"
    And I should see " Located at:  C:\temp\path with spaces\IronRuby-091\bin"

  Scenario: install Ruby 1.8.6
    When I run "pik in ruby 1.8"
    Then I should see "** Downloading:  http://rubyforge.org/frs/download.php/62267/ruby-1.8.6-p383-i386-mingw32.7z"
    And I should see "   to:  C:\temp\path with spaces\downloads\ruby-1.8.6-p383-i386-mingw32.7z"
    And I should see "** Extracting:  C:\temp\path with spaces\downloads\ruby-1.8.6-p383-i386-mingw32.7z"
    And I should see "** Adding:  186: ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]"
    And I should see " Located at:  C:\temp\path with spaces\Ruby-186-p383\bin"