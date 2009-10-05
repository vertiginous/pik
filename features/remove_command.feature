Feature: remove command
  In order to remove ruby versions from pik
  A developer
  Wants a command line interface
  So that she can remove versions.

  Scenario: remove a version that has already been added
    Given I have already added "ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]"
    When I run "pik remove 186 min -f"
    Then I should see "removed"    
    And the version should be removed.
        