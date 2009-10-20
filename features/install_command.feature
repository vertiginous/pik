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
