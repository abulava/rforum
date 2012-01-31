Feature: Create topics
  In order to add a new topic for discussion
  As a signed-in user
  I want to create topics

Scenario: Creating a topic
  Given I am signed-in as a user "John"
  Then I add a "something new" topic with a "starting" message
  And I should see a notification message "created"
  And a message containing "starting" should be in a topic titled "something new"

Scenario: Failing to add an invalid topic
  Given I am signed-in as a user "John"
  Then I should not add a topic with a too short title
  And I should see an error explanation "too short"
