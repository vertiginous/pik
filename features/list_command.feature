Feature: list command
  In order to list ruby versions that pik is aware of
  A developer
  Wants an interface to the program
  So that he can list configuration information

  Scenario: list versions
    When I run "pik list"
    Then I should find "^\d+\: .+ruby"

  Scenario: Determining the current ruby version from the list
    When I run "pik list"
    Then I should find "^\d+\: .+\*$"
    
  Scenario: list verbose output
    When I run "pik list -v"
    Then I should find "^\d+\: .+\*$"
    And I should find "path\: C\:[\\\/].+"
    
  Scenario: list remote packages
    When I run "pik list -r"
    And I should see "IronRuby:"
    And I should see "0.9.1:"
    And I should see "JRuby:"
    And I should see "1.4.0RC3:"
    Then I should see "Ruby:"
    And I should see " 1.8.6-p383"