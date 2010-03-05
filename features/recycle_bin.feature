Feature: Recycle Bin
  In order to recover deleted items
  A User
  wants a recycle bin

  Scenario: Recycle bin navigation
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the leads page
    When I press "delete_erich-feldmeier"
    Then I should see "(1)"

  Scenario: Private item (in)visibility
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And a lead: "erich" exists with user: benny, permission: "Private"
    And erich has been deleted
    When I go to the recycle bin page
    Then I should not see "Erich"
    And I should not see "Recycle Bin (1)"

  Scenario: Restoring a lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the leads page
    And I press "delete_erich-feldmeier"
    And I go to the recycle bin page
    When I press "restore_erich-feldmeier"
    Then I should be on the recycle bin page
    And a lead should exist with deleted_at: nil
    And I should see "Recycle Bin"
    And I should not see "Recycle Bin (1)"

  Scenario: Permanently deleting a lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And erich has been deleted
    When I go to the recycle bin page
    And I press "delete_erich-feldmeier"
    Then I should be on the recycle bin page
    And a lead should not exist with first_name: "Erich"
    And I should see "Recycle Bin"
    And I should not see "Recycle Bin (1)"

  Scenario: Restoring a contact
    Given I am registered and logged in as annika
    And a contact: "florian" exists with user: annika
    And I am on the contacts page
    And I press "delete_florian-behn"
    And I go to the recycle bin page
    When I press "restore_florian-behn"
    Then I should be on the recycle bin page
    And a contact should exist with deleted_at: nil

  Scenario: Permanently deleting a contact
    Given I am registered and logged in as annika
    And a contact: "florian" exists with user: annika
    And florian has been deleted
    When I go to the recycle bin page
    And I press "delete_florian-behn"
    Then I should be on the recycle bin page
    And a contact should not exist with first_name: "Florian"

  Scenario: Restoring an account
    Given I am registered and logged in as annika
    And an account: "careermee" exists with user: annika
    And I am on the accounts page
    And I press "delete_careermee"
    And I go to the recycle bin page
    When I press "restore_careermee"
    Then I should be on the recycle bin page
    And an account should exist with deleted_at: nil

  Scenario: Permanently deleting an account
    Given I am registered and logged in as annika
    And an account: "careermee" exists with user: annika
    And careermee has been deleted
    When I go to the recycle bin page
    And I press "delete_careermee"
    Then I should be on the recycle bin page
    And an account should not exist with name: "CareerMee"
