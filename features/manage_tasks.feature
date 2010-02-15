Feature: Manage tasks
  In order to remember to do jobs
  A User
  wants to add, update, delete and be reminded of tasks

  Scenario: Viewing my tasks
    Given I am registered and logged in as annika
    And a task exists with user: annika, name: "Task for Annika"
    And user: "benny" exists
    And a task exists with user: benny, name: "Task for Benny"
    When I go to the tasks page
    Then I should see "Task for Annika"
    And I should not see "Task for Benny"

  Scenario: Re-assiging a task
    Given I am registered and logged in as annika
    And user: "benny" exists with email: "benjamin.pochhammer@1000jobboersen.de"
    And a task: "call_erich" exists with user: annika
    And I am on the task's edit page
    When I select "benjamin.pochhammer@1000jobboersen.de" from "task_assignee_id"
    And I press "task_submit"
    Then I should be on the tasks page
    And I should see "Task has been re-assigned"
    And a task re-assignment email should have been sent to "benjamin.pochhammer@1000jobboersen.de"
    And a new "Re-assigned" activity should have been created for "Task" with "name" "Call erich to get offer details"
