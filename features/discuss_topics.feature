Feature: Discuss topics
  In order to participate in topic discussion
  As a signed-in user
  I want to create and delete messages in the topic

Scenario: Adding a message on topic
  Given the following user exists:
    | Name |
    | John |
  And the following messages exist:
    | Content   | Topic             |
    | cuke      | Title: BDD        |
    | message 1 | Title: count to 2 |
  And I am signed-in as a user "John"
  And I am on the "BDD" topic page
  When I am posted a message containing "true"
  Then a message containing "true" should be in a topic titled "BDD"
  And I should be on the "BDD" topic page
  Given I am on the "count to 2" topic page
  When I am posted a message containing "message 2"
  Then a message containing "message 2" should be in a topic titled "count to 2"
  Then I should be on the "count to 2" topic page

Scenario: Adding messages by different users
  Given the following user exists:
    | Name |
    | John |
  And the following messages exist:
    | Content     | User       | Topic      |
    | by 1st user | Name: Jill | Title: BDD |
  And I am signed-in as a user "John"
  When I am on the "BDD" topic page
  Then I should see a message "by 1st user" posted by a user "Jill"
  And I should not see a message "by 2nd user" posted by a user "John"
  When I am posted a message containing "by 2nd user"
  Then I should see a message "by 2nd user" posted by a user "John"

Scenario: Failing to add an invalid message
  Given the following user exists:
    | Name |
    | John |
  And the following topic exists:
    | Title      |
    | validate   |
  And I am signed-in as a user "John"
  And I am on the "validate" topic page
  When I am posted a message containing "no"
  Then I should be on the new message page in a topic titled "validate"
  And I should see an error explanation "Content is too short"
  And I should see a value "no" in a field "Content"

Scenario: A user is able to delete only own messages
  Given the following users exist:
    | Name |
    | Jill |
    | John |
  And the following messages exist:
    | Content          | Topic      | User       |
    | forbidden        | Title: BDD | Name: Jill |
    | could be deleted | Title: BDD | Name: John |
  And I am signed-in as a user "John"
  When I am on the "BDD" topic page
  Then I cannot delete "forbidden" message
  And I delete "could be deleted" message with a notification message "destroyed"
