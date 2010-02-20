Feature: Manage users
  In order to manage their personal details and settings
  A User
  wants to manage themselves

  Scenario: Viewing your profile
    Given I am registered and logged in as annika
    And I am on the dashboard page
    When I follow "profile"
    Then I should see "annika.fleischer@1000jobboersen.de"
    And I should see "My Profile"
    And I should see "dropbox@"
    And an activity should not exist
