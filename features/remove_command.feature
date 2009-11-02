Feature: remove command
  In order to remove ruby versions from pik
  A developer
  Wants a command line interface
  So that she can remove versions.

  Scenario: remove a version from the config
    Given I have already added "ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]"
    When I run "pik remove 186 383 -f"
    Then I should see "removed"    
    And the version should be removed.