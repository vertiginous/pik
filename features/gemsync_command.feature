Feature: gemsync command
  In order to test code against specific ruby implementations
  A developer
  Wants an interface to the program
  So that he can tag versions that pik is aware of
  
  Scenario: sync to previous version
    Given I only have the rake gem installed to version 1.9.1.
    When I run "pik 191 mi" and "pik gemsync 186 mi -q -d",
    Then I should see "** Syncing"
    And I should find "Gem rake.+ already installed"
    And I should see "Installing hoe"

  Scenario: attempt to sync to different platform
    When I run "pik iron" and "pik gemsync 186 mi -q -d",
    Then I should see "You appear to be attempting a gemsync from a different platform."
    
    
  # Scenaorio: sync remotely 