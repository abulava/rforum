Feature: Browse messages on topic
  In order to browse through the messages on topic
  As a visitor
  I want to be able to read the messages on topic

Scenario: Browsing a single message on topic
  Given the following messages exist:
    | Content | Topic       |
    | orange  | Title: food |
    | shirt   | Title: wear |
  When I am on the "food" topic page
  Then I should see a message with the content "orange"
  And I should not see a message with the content "shirt"
