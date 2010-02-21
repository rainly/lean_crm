Feature: Manage leads
  In order to keep track of leads
  A user
  wants manage leads

  Scenario: Creating a lead
    Given I am registered and logged in as annika
    And I am on the leads page
    And I follow "new"
    And I fill in "lead_first_name" with "Erich"
    And I fill in "lead_last_name" with "Feldmeier"
    When I press "lead_submit"
    Then I should be on the leads page
    And I should see "Erich Feldmeier"
    And a created activity should exist for lead with first_name "Erich"

  Scenario: Creating a lead via XML
    Given I am registered and logged in as annika
    When I POST attributes for lead: "erich" to the leads page
    Then 1 leads should exist

  Scenario: Adding a comment
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And I am on the lead's page
    And I fill in "comment_text" with "This is a good lead"
    When I press "comment_submit"
    Then I should be on the lead page
    And I should see "This is a good lead"
    And 1 comments should exist

  Scenario: Adding an comment with an attachment
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And I am on the lead's page
    And I fill in "comment_text" with "Sent offer"
    And I attach the file at "test/upload-files/erich_offer.pdf" to "Attachment"
    When I press "comment_submit"
    Then I should be on the lead page
    And I should see "Sent offer"
    And I should see "erich_offer.pdf"

  Scenario: Editing a lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the leads page
    And I follow "edit_erich-feldmeier"
    And I fill in "lead_phone" with "999"
    When I press "lead_submit"
    Then I should be on the leads page
    And a lead should exist with phone: "999"
    And an updated activity should exist for lead with first_name "Erich"

  Scenario: Deleting a lead
    Given I am registered and logged in as annika
    And a lead "erich" exists with user: annika
    And I am on the leads page
    When I press "delete_erich-feldmeier"
    Then I should be on the leads page
    And lead "erich" should have been deleted
    And a new "Deleted" activity should have been created for "Lead" with "first_name" "Erich"

  Scenario: Filtering leads
    Given I am registered and logged in as annika
    And a lead exists with user: annika, status: "New", first_name: "Erich"
    And a lead exists with user: annika, status: "Rejected", first_name: "Markus"
    And I go to the leads page
    When I check "new"
    And I press "filter"
    Then I should see "Erich"
    And I should not see "Markus"

  Scenario: Deleted leads
    Given I am registered and logged in as annika
    And a lead: "kerstin" exists with user: annika
    When I am on the leads page
    Then I should not see "Kerstin"

  Scenario: Viewing a lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the dashboard page
    And I follow "leads"
    When I follow "erich-feldmeier"
    Then I should be on the lead page
    And I should see "Erich"
    And a view activity should have been created for lead with first_name "Erich"

  Scenario: Adding a task to a lead
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And I am on the lead's page
    And I follow "add_task"
    And I fill in "task_name" with "Call to get offer details"
    And I select "As soon as possible" from "task_due_at"
    And I select "Call" from "task_category"
    When I press "task_submit"
    Then I should be on the lead's page
    And a task should have been created
    And I should see "Call to get offer details"

  Scenario: Marking a lead as completed
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And a task exists with asset: the lead, name: "Call to get offer details", user: annika
    And I am on the lead's page
    When I check "task_completed_by_id"
    And I press "task_submit"
    Then the task "Call to get offer details" should have been completed
    And I should be on the lead's page
    And I should not see "Call to get offer details"

  Scenario: Deleting a task
    Given I am registered and logged in as annika
    And a lead exists with user: annika
    And a task exists with asset: the lead, name: "Call to get offer details", user: annika
    And I am on the lead's page
    When I press "Delete Task"
    Then I should be on the lead's page
    And a task should not exist
    And I should not see "Call to get offer details"

  Scenario: Rejecting a lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the lead's page
    When I press "reject"
    Then I should be on the leads page
    And lead "erich" should exist with status: 3
    And a new "Rejected" activity should have been created for "Lead" with "first_name" "Erich"

  Scenario: Converting a lead to a new account
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the lead's page
    When I follow "convert"
    And I fill in "account_name" with "World Dating"
    And I press "convert"
    Then I should be on the account page
    And I should see "World Dating"
    And I should see "Erich"
    And an account should exist with name: "World Dating"
    And a contact should exist with first_name: "Erich"
    And a lead should exist with first_name: "Erich", status: 2
    And a new "Converted" activity should have been created for "Lead" with "first_name" "Erich"

  Scenario: Converting a lead to an existing account
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And a account: "careermee" exists with user: annika
    And I am on the lead's page
    When I follow "convert"
    And I select "CareerMee" from "account_id"
    And I press "convert"
    Then I should be on the account page
    And I should see "CareerMee"
    And I should see "Erich"
    And 1 accounts should exist

  Scenario: Trying to convert a lead without entering an account name
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika
    And I am on the lead's page
    When I follow "convert"
    And I press "convert"
    Then I should be on the lead's promote page

  Scenario: Private lead (in)visiblity on leads page
    Given I am registered and logged in as annika
    And user: "benny" exists
    And a lead: "erich" exists with user: benny, permission: "Private"
    And a lead: "markus" exists with user: benny, permission: "Public"
    When I go to the leads page
    Then I should not see "Erich"
    And I should see "Markus"

  Scenario: Shared lead visibility on leads page
    Given I am registered and logged in as benny
    And a lead: "markus" exists with user: benny, permission: "Private"
    And user: "annika" exists
    And I go to the new lead page
    And I fill in "lead_first_name" with "Erich"
    And I fill in "lead_last_name" with "Feldmeier"
    And I select "Shared" from "lead_permission"
    And I select "annika.fleischer@1000jobboersen.de" from "lead_permitted_user_ids"
    And I press "lead_submit"
    And I logout
    And I login as annika
    When I go to the leads page
    Then I should see "Erich"
    And I should not see "Markus"

  Scenario: Shared lead (in)visibility on leads page
    Given I am registered and logged in as annika
    And user: "benny" exists
    And a lead: "erich" exists with user: benny
    And a lead: "markus" exists with user: benny
    And erich is shared with annika
    And markus is not shared with annika
    When I go to the leads page
    Then I should see "Erich"
    And I should not see "Markus"

  Scenario: Viewing a shared lead details
    Given I am registered and logged in as annika
    And user: "benny" exists
    And a lead: "erich" exists with user: benny
    And erich is shared with annika
    And I am on the leads page
    When I follow "erich-feldmeier"
    Then I should see "Erich"
    And I should be on the lead's page

  Scenario: Actions for a converted lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika, status: "Converted"
    When I am on the lead's page
    Then I should not see "convert"
    And I should not see "reject"

  Scenario: Actions for a rejected lead
    Given I am registered and logged in as annika
    And a lead: "erich" exists with user: annika, status: "Rejected"
    When I am on the lead's page
    Then I should not see "convert"
    And I should not see "reject"
