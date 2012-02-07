Feature: Discuss topics
  In order to participate in topic discussion
  As a signed-in user
  I want to create and delete messages in the topic

Scenario: Adding a message on topic
  Given a user exists
  And the following messages exist:
    | Content | Topic       |
    | apple   | Title: food |
    | shirt   | Title: wear |
  And I am signed-in as a user
  And I am on the "food" topic page
  When I post a message containing "orange" to a topic titled "food"
  Then I should be on the "food" topic page
  And a message containing "orange" should be in a topic titled "food"
  Given I am on the "wear" topic page
  When I post a message containing "pants" to a topic titled "wear"
  Then I should be on the "wear" topic page
  And a message containing "pants" should be in a topic titled "wear"

Scenario: Adding messages by different users
  Given a user exists with a name of "Jill"
  And a user exists with a name of "John"
  And a topic exists with a title of "BDD"
  And I am signed-in as a user "John"
  When I am on the "BDD" topic page
  And I post a message containing "John writes" to a topic titled "BDD"
  Then I should see a message "John writes" posted by a user "John"
  Given I am signed-out
  And I am signed-in as a user "Jill"
  When I am on the "BDD" topic page
  And I post a message containing "Jill writes" to a topic titled "BDD"
  Then I should see a message "Jill writes" posted by a user "Jill"

Scenario: Failing to add an invalid message
  Given a user exists
  And a topic exists with a title of "validate"
  And I am signed-in as a user
  And I am on the "validate" topic page
  Then I should not add an invalid message in a topic titled "validate"

Scenario: Adding a message with attaches
  Given a user exists
  And a topic exists with a title of "BDD"
  And I am signed-in as a user
  When I am on the "BDD" topic page
  And I post a message with attaches to a topic titled "BDD"
  Then I should see a message with attaches in a topic titled "BDD"

Scenario: A user is able to delete only own messages
  Given the following messages exist:
    | Content          | Topic      | User       |
    | forbidden        | Title: BDD | Name: Jill |
    | could be deleted | Title: BDD | Name: John |
  And I am signed-in as a user "John"
  When I am on the "BDD" topic page
  Then I cannot delete "forbidden" message
  And I delete "could be deleted" message with a flash notification "destroyed"

Scenario: A user is unable to delete a last message in a topic
  Given the following message exists:
    | Content  | Topic      | User       |
    | last one | Title: BDD | Name: John |
  And I am signed-in as a user "John"
  When I am on the "BDD" topic page
  Then I cannot delete "last one" message
