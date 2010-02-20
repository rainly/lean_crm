Feature: Manage configurations
  In order to setup the CRM for their users individual needs
  An Admin
  wants to manage configuration

  Scenario: Editing Configuration
    Given an admin: "matt" exists
    And I login as an administrator: "matt"
    And I follow "edit_configuration"
    And I fill in "configuration_imap_user" with "mr_blobby"
    And I fill in "configuration_imap_password" with "blobby"
    And I fill in "configuration_imap_host" with "imap.gmail.com"
    When I press "configuration_submit"
    Then I should be on the admin configuration page

  Scenario: Starting the CRM without any configuration
    Given no configuration exists
    When I go to the dashboard page
    Then a configuration should have been created
