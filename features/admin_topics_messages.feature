Feature: Administer messages and topics
  In order to administer discussions
  As an admin user
  I want to delete messages and topics

Scenario: An admin is able to delete any user's messages
  Given the following users exist:
    | Name | admin |
    | John | false |
    | Jill | true  |
  And the following messages exist:
    | Content     | Topic      | User       |
    | last msg    | Title:BDD  | Name: Jill |
    | as an owner | Title: BDD | Name: Jill |
    | as an admin | Title: BDD | Name: John |
  And I am signed-in as a user "Jill"
  When I am on the "BDD" topic page
  Then I delete "as an owner" message with a flash notification "destroyed"
  And I delete "as an admin" message with a flash notification "destroyed"

Scenario: An admin is able to delete topics
  Given the following users exist:
    | Name | admin |
    | John | false |
    | Jill | true  |
  And a topic exists with a title of "should be deleted"
  And I am signed-in as a user "John"
  When I am on the home page
  Then I could not delete "should be deleted" topic
  And I am signed-out
  And I am signed-in as a user "Jill"
  When I am on the home page
  Then I could delete "should be deleted" topic
