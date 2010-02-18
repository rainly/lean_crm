Feature: Manage accounts
  In order to keep track of accounts and associated contacts
  A User
  wants to manage accounts

  Scenario: Creating an account
    Given I am registered and logged in as annika
    And I am on the accounts page
    And I follow "new"
    And I fill in "account_name" with "CareerMee"
    When I press "account_submit"
    Then I should be on the account page
    And I should see "CareerMee"
    And a new "Created" activity should have been created for "Account" with "name" "CareerMee"

  Scenario: Editing an account
    Given I am registered and logged in as annika
    And account: "careermee" exists with user: annika
    And I am on the account's page
    And I follow "edit"
    And I fill in "account_name" with "a test"
    When I press "account_submit"
    Then I should be on the account's page
    And I should see "a test"
    And I should not see "CareerMee"
    And a new "Updated" activity should have been created for "Account" with "name" "a test"

  Scenario: Viewing accounts
    Given I am registered and logged in as annika
    And account: "careermee" exists with user: annika
    And I am on the dashboard page
    When I follow "accounts"
    Then I should see "CareerMee"
    And I should be on the accounts page

  Scenario: Viewing an account
    Given I am registered and logged in as annika
    And account: "careermee" exists with user: annika
    And I am on the dashboard page
    And I follow "accounts"
    When I follow "careermee"
    Then I should see "CareerMee"
    And I should be on the account page
    And a new "Viewed" activity should have been created for "Account" with "name" "CareerMee"
