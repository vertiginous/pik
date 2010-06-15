Feature: default command
  In order to easily get back to the original ruby version
  A developer
  Wants a command line interface
  That allows her to switch back to the system defined version.

  Scenario: switching to the default version
    Given I am currently using "ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32]"
    When I run "pik default -v" and check the path
    Then I should see "ruby 1.8.7 (2010-01-10 patchlevel 249) [i386-mingw32]"
    And the path should point to "C:\Ruby\ruby-187-p249\bin"