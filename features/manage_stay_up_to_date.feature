Feature: Stay up to date
  In order to monitor items
  A User
  wants to receive update item updates

  Scenario: Registering for updates on a lead
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And a lead: "erich" exists with user: benny
    When I am on the lead's page
    And I press "keep_me_updated"
    Then I should be on the lead's page
    And annika should be observing the lead
    And I should not see "keep_me_updated"

  Scenario: Registering for updates on a contact
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And a contact: "florian" exists with user: benny
    When I am on the contact's page
    And I press "keep_me_updated"
    Then I should be on the contact's page
    And annika should be observing the contact
    And I should not see "keep_me_updated"

  Scenario: Registering for updates on an account
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And an account: "careermee" exists with user: benny
    When I am on the account's page
    And I press "keep_me_updated"
    Then I should be on the account's page
    And annika should be observing the account
    And I should not see "keep_me_updated"

  Scenario: De-registering for updates on a lead
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And a lead: "erich" exists with user: benny
    And I am on the lead's page
    And I press "keep_me_updated"
    When I press "stop_updating_me"
    Then I should be on the lead's page
    And I should see "keep_me_updated"
    And I should not see "stop_updating_me"
    And annika should not be observing the lead

  Scenario: De-registering for updates on a contact
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And a contact: "florian" exists with user: benny
    And I am on the contact's page
    And I press "keep_me_updated"
    When I press "stop_updating_me"
    Then I should be on the contact's page
    And I should see "keep_me_updated"
    And I should not see "stop_updating_me"
    And annika should not be observing the contact

  Scenario: De-registering for updates on an account
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And an account: "careermee" exists with user: benny
    And I am on the account's page
    And I press "keep_me_updated"
    When I press "stop_updating_me"
    Then I should be on the account's page
    And I should see "keep_me_updated"
    And I should not see "stop_updating_me"
    And annika should not be observing the account
