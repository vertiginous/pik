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
    When I run "pik 191" and "pik tag mingw",
    And I run "pik 186 383" and "pik tag mingw",
    And I run "pik tags mingw run echo."
    Then I should see "ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]"
    And I should see "ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32]"
