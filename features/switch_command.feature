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
      | version                                                   | patterns |
      | IronRuby 0.9.0.0 on .NET 2.0.0.0                          | Ir 90    |
      | IronRuby 0.9.1.0 on .NET 2.0.0.0                          | Ir 91    |
      | jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d)         | jruby    |
      | ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]      | 185      |
      | ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]     | 186 ms   |
      | ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]     | 186 mi   |
      | ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32] | 191 p1   |
      | ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32] | 191 p2   |
      
  Scenario Outline: Switching versions with pattern only
    Given I have added "<version>" to pik
    When I run "pik sw <patterns> -v" and check the path
    Then I should see "<version>"
    And the path should point to it.
    And the GEM_HOME might get set.

    Examples:
      | version                                                   | patterns |
      | IronRuby 0.9.0.0 on .NET 2.0.0.0                          | Ir 90    |
      | IronRuby 0.9.1.0 on .NET 2.0.0.0                          | Ir 91    |
      | jruby 1.3.1 (ruby 1.8.6p287) (2009-06-15 2fd6c3d)         | jruby    |
      | ruby 1.8.5 (2006-12-25 patchlevel 12) [i386-mswin32]      | 185      |
      | ruby 1.8.6 (2008-08-11 patchlevel 287) [i386-mswin32]     | 186 ms   |
      | ruby 1.8.6 (2009-03-31 patchlevel 368) [i386-mingw32]     | 186 mi   |
      | ruby 1.9.1p129 (2009-05-12 revision 23412) [i386-mingw32] | 191 p1   |
      | ruby 1.9.1p243 (2009-07-16 revision 24175) [i386-mingw32] | 191 p2   |
      