Feature: Recycle Bin
  In order to recover deleted items
  A User
  wants a recycle bin

  Scenario: Recycle bin navigation
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the leads page
    When I click the delete button for the lead
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
    And I click the delete button for the lead
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
    And I click the delete button for the lead
    Then I should be on the recycle bin page
    And a lead should not exist with first_name: "Erich"
    And I should see "Recycle Bin"
    And I should not see "Recycle Bin (1)"

  Scenario: Permanently deleting a lead with comments
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And benny belongs to the same company as annika
    And a lead "erich" exists with user: benny
    And a comment exists with user: benny, commentable: lead, text: "Delete me too!"
    And I am on the leads page
    When I click the delete button for the lead
    Then I should be on the leads page
    And a new "Deleted" activity should have been created for "Lead" with "first_name" "Erich" and user: "annika"
    When I follow "recycle_bin"
    And I click the delete button for the lead
    Then I should not see "Erich" within "#main"
    When I follow "Dashboard"
    Then I should be on the dashboard page
    And I should not see "Delete me too!"

  Scenario: Restoring a contact
    Given I am registered and logged in as annika
    And a contact: "florian" exists with user: annika
    And I am on the contacts page
    And I click the delete button for the contact
    And I go to the recycle bin page
    When I press "restore_florian-behn"
    Then I should be on the recycle bin page
    And a contact should exist with deleted_at: nil

  Scenario: Permanently deleting a contact
    Given I am registered and logged in as annika
    And a contact: "florian" exists with user: annika
    And florian has been deleted
    When I go to the recycle bin page
    And I click the delete button for the contact
    Then I should be on the recycle bin page
    And a contact should not exist with first_name: "Florian"

  Scenario: Deleting a contact with comments
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And benny belongs to the same company as annika
    And a contact "florian" exists with user: benny
    And a comment exists with user: benny, commentable: contact, text: "Delete me too!"
    And I am on the contacts page
    When I click the delete button for the contact
    Then I should be on the contacts page
    And a new "Deleted" activity should have been created for "Contact" with "first_name" "Florian" and user: "annika"
    When I follow "recycle_bin"
    And I click the delete button for the contact
    Then I should not see "Florian" within "#main"
    When I follow "Dashboard"
    Then I should be on the dashboard page
    And I should not see "Delete me too!"
    
  Scenario: Restoring an account
    Given I am registered and logged in as annika
    And an account: "careermee" exists with user: annika
    And I am on the accounts page
    And I click the delete button for the account
    And I go to the recycle bin page
    When I press "restore_careermee"
    Then I should be on the recycle bin page
    And an account should exist with deleted_at: nil

  Scenario: Permanently deleting an account
    Given I am registered and logged in as annika
    And an account: "careermee" exists with user: annika
    And careermee has been deleted
    When I go to the recycle bin page
    And I click the delete button for the account
    Then I should be on the recycle bin page
    And an account should not exist with name: "CareerMee"
    
  Scenario: Permanently deleting an account with comments
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And benny belongs to the same company as annika
    And account: "careermee" exists with user: benny
    And a comment exists with user: benny, commentable: account, text: "Delete me too!"
    And I am on the accounts page
    When I click the delete button for the account
    Then I should be on the accounts page
    And I should not see "CareerMee" within "#main"
    And a new "Deleted" activity should have been created for "Account" with "name" "CareerMee" and user: "annika"
    When I follow "recycle_bin"
    And I click the delete button for the account
    Then I should not see "careermee"
    When I follow "Dashboard"
    Then I should be on the dashboard page
    And I should not see "Delete me too!"
