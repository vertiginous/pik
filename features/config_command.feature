Feature: config command
  In order to use multiple ruby versions effectively.
  A developer
  Wants a command line interface
  That allows her to configure pik's behavior.
  
  Scenario: config gem_home
    Given I have already added "ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]"
    And I am currently using it.
    When I run "pik config gem_home default" 
    Then a gem_home option should be added to the config.
        