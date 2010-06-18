Feature: use command
  In order to switch from one ruby version to another
  A developer
  Wants an interface to the program
  So that she can easily update the path and other environment variables.

  Scenario Outline: Switching versions with use command
    Given I have added "<version>" to pik
    When I run "pik use <patterns> -v" and check the path
    Then I should see "<version>"
    And the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns  |
      | IronRuby 0.9.2.0 on .NET 2.0.0.0                          | iron 92   |
      | jruby 1.5.1 (ruby 1.8.7 patchlevel 249)                   | jruby 1.5 |
      | ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]     | 186 398   |
      | ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32] | 191 p3    |
      
  Scenario Outline: Switching versions with pattern only
    Given I have added "<version>" to pik
    When I run "pik <patterns>" and check the path
    Then the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns  |
      | IronRuby 0.9.2.0 on .NET 2.0.0.0                          | iron 92   |
      | jruby 1.5.1 (ruby 1.8.7 patchlevel 249)                   | jruby 1.5 |
      | ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]     | 186 398   |
      | ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32] | 191 p3    |
  
   Scenario Outline: Switching versions with no ruby in the path
    Given I have added "<version>" to pik
    And there is no ruby version in the path
    When I run "pik <patterns>" and check the path
    Then the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns  |
      | IronRuby 0.9.2.0 on .NET 2.0.0.0                          | iron 92   |
      | jruby 1.5.1 (ruby 1.8.7 patchlevel 249)                   | jruby 1.5 |
      | ruby 1.8.6 (2010-02-04 patchlevel 398) [i386-mingw32]     | 186 398   |
      | ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-mingw32] | 191 p3    |
 