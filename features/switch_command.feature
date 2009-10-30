Feature: switch command
  In order to switch from one ruby version to another
  A developer
  Wants an interface to the program
  So that she can easily update the path and other environment variables.

  Scenario Outline: Switching versions with switch command
    Given I have added "<version>" to pik
    When I run "pik switch <patterns> -v" and check the path
    Then I should see "<version>"
    And the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns  |
      | IronRuby 0.9.1.0 on .NET 2.0.0.0                          | Ir 91     |
      | jruby 1.4.0RC2 (ruby 1.8.7 patchlevel 174)                | jruby 1.4 |
      | ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]     | 186 383   |
      | ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32] | 191 p2    |
      
  Scenario Outline: Switching versions with pattern only
    Given I have added "<version>" to pik
    When I run "pik <patterns>" and check the path
    Then the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns  |
      | IronRuby 0.9.1.0 on .NET 2.0.0.0                          | Ir 91     |
      | jruby 1.4.0RC2 (ruby 1.8.7 patchlevel 174)                | jruby 1.4 |
      | ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]     | 186 383   |
      | ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32] | 191 p2    |
 
   Scenario Outline: Switching versions with no ruby in the path
    Given I have added "<version>" to pik
    And there is no ruby version in the path
    When I run "pik <patterns>" and check the path
    Then the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns  |
      | IronRuby 0.9.1.0 on .NET 2.0.0.0                          | Ir 91     |
      | jruby 1.4.0RC2 (ruby 1.8.7 patchlevel 174)                | jruby 1.4 |
      | ruby 1.8.6 (2009-08-04 patchlevel 383) [i386-mingw32]     | 186 383   |
      | ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32] | 191 p2    |     