Feature: Manage contacts on the account's show page
  In order to keep track of the account's contacts
  A User
  wants to manage each contact along with its tasks and comments

  Scenario: Viewing comments for a contact
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And account: "careermee" exists with user: benny
    And a contact: "florian" exists with user: benny, account: the account
    And a comment exists with text: "CareerMee is cool", user: benny, commentable: the contact
    And I am on the account's page
    Then I should see "CareerMee is cool" within "#main"
    And I should not see the edit link for the comment
    And I should not see the delete link for the comment
    
  Scenario: Updating a comment for a contact
   Given I am registered and logged in as annika
   And account: "careermee" exists with user: annika
   And a contact: "florian" exists with user: annika, account: the account
   And a comment exists with text: "CareerMee is cool", user: annika, commentable: the contact
   And I am on the account's page
   When I follow the edit link for the comment
   And I should be on the comment's edit page
   And I fill in "comment_text" with "CareerMee WAS cool"
   And I press "update_comment"
   Then I should be on the account's page
   And I should see "CareerMee WAS cool" within "#main"
  
  Scenario: Deleting a comment for a contact
    Given I am registered and logged in as annika
    And account: "careermee" exists with user: annika
    And a contact: "florian" exists with user: annika, account: the account
    And a comment exists with user: annika, commentable: the contact, text: "CareerMee is cool"
    And I am on the account's page
    When I click the delete button for the comment
    Then I should be on the account's page
    And I should not see "Some account this is"
  
  Scenario: Viewing tasks for a contact
    Given I am registered and logged in as annika
    And a user: "benny" exists
    And account: "careermee" exists with user: benny
    And a contact: "florian" exists with user: benny, account: the account
    And a task exists with name: "Follow up and close the deal", user: benny, asset: the contact
    And I am on the account's page
    Then I should see "Follow up and close the deal" within "#main"

  Scenario: Updating a task for a contact
    Given I am registered and logged in as annika
    And account: "careermee" exists with user: annika
    And a contact: "florian" exists with user: annika, account: the account
    And a task exists with name: "Follow up and close the deal", user: annika, asset: the contact
    And I am on the account's page
    When I follow the edit link for the task
    And I fill in "task_name" with "Follow up and close the deal NOW"
    And I press "update_task"
    Then I should be on the account's page
    And I should see "Follow up and close the deal NOW" within "#main"

  Scenario: Deleting a task for a contact
    Given I am registered and logged in as annika
    And account: "careermee" exists with user: annika
    And a contact: "florian" exists with user: annika, account: the account
    And a task exists with user: annika, asset: the contact, name: "Follow up and close the deal"
    And I am on the account's page
    When I click the delete button for the task
    Then I should be on the account's page
    And I should not see "Some account this is"
