Feature: Administer messages and topics
  In order to administer discussions
  As an admin user
  I want to delete messages and topics

Scenario: An admin is able to delete any messages
  Given the following users exist:
    | Name | admin |
    | John | false |
    | Jill | true  |
  And the following messages exist:
    | Content     | Topic      | User       |
    | as an owner | Title: BDD | Name: Jill |
    | as an admin | Title: BDD | Name: John |
  And I am signed-in as a user "Jill"
  When I am on the "BDD" topic page
  Then I delete "as an owner" message with a notification message "destroyed"
  And I delete "as an admin" message with a notification message "destroyed"
