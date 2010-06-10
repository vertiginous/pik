Feature: config command
  In order to use multiple ruby versions effectively.
  A developer
  Wants a command line interface
  That allows her to configure pik's behavior.
  
  Scenario: config gem_home
    Given I am currently using "ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]"
    When I run "pik config gem_home default" 
    Then a gem_home option should be added to the config.
        