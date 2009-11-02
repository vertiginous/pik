Feature: default command
  In order to easily get back to the original ruby version
  A developer
  Wants a command line interface
  That allows her to switch back to the system defined version.

  Scenario: switching to the default version
    Given I am currently using "ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]"
    When I run "pik default -v" and check the path
    Then I should see "ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]"
    And the path should point to "c:\ruby\Ruby-186-p383\bin"