Feature: tag command
  In order to test code against specific ruby implementations
  A developer
  Wants an interface to the program
  So that he can tag versions that pik is aware of
  
  Scenario: tag version
    When I run "pik Ir 92" and "pik tag iron",
    And I run "pik config list"
    Then I should find "tags: \n  iron:"
    And I should see "  - 092: IronRuby 0.9.2.0 on .NET 2.0.0.0"

  Scenario: run tagged versions
    When I run "pik 191" and "pik tag mingw",
    And I run "pik 186" and "pik tag mingw",
    And I run "pik tags mingw run echo."
    Then I should see "ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]"
    And I should see "ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32]"

  Scenario: run tags with no options
    When I run "pik tags"
    Then I should see "The tags command allows you to run a subset of versions."
    And I should see "C:\>pik tags mingw,jruby gem install my_gem"