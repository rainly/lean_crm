Feature: Manage activities
  In order to keep track of what they have done, and easily return to past items
  A User
  wants to keep an activity history

  Scenario: Activities on the dashboard
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    When I am on the dashboard page
    Then I should see "annika.fleischer@1000jobboersen.de"
    And I should see "created lead"
