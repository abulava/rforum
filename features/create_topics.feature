Feature: Create topics
  In order to add a new topic for discussion
  As a signed-in user
  I want to create topics

Scenario: Creating a topic
  Given a user exists
  And I am signed-in as a user
  Then I add a "something new" topic with a "starting" message

Scenario: Failing to add an invalid topic
  Given a user exists
  And I am signed-in as a user
  Then I should not add a topic with a too short title
