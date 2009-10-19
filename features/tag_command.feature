Feature: tag command
  In order to test code against specific ruby implementations
  A developer
  Wants an interface to the program
  So that he can tag versions that pik is aware of
  
  Scenario: tag version
    When I run "pik Ir 91" and "pik tag iron",
    And I run "pik config list"
    Then I should find "tags: \n  iron:"
    And I should see "  - 091: IronRuby 0.9.1.0 on .NET 2.0.0.0"

  Scenario: run tagged versions
    When I run "pik Ir 91" and "pik tag iron",
    And I run "pik Ir 90" and "pik tag iron",
    And I run "pik tags iron run echo."
    Then I should find "IronRuby 0.9.1.0 on .NET 2.0.0.0"
    And I should find "IronRuby 0.9.0.0 on .NET 2.0.0.0"
