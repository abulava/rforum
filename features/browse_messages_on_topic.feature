Feature: Browse messages on topic
  In order to browse through the messages on topic
  As a visitor
  I want to be able to read the messages on topic

Scenario: Browsing a single message on topic
  Given the following topic exists:
    | Title      |
    | count to 1 |
  And the following messages exist:
    | Content   | Topic             |
    | message 1 | Title: count to 1 |
    | message 2 | Title: BDD        |
  When I am on the topic "count to 1" page
  Then I should see a message with the content "message 1"
  And I should not see a message with the content "message 2"
