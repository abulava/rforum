Feature: Browse messages in a topic
  In order to browse through the messages in a topic
  As a visitor
  I want to be able to read the messages in a topic

Scenario: Browsing a single message in a topic
  Given the following messages exist:
    | Content | Topic       |
    | orange  | Title: food |
    | shirt   | Title: wear |
  When I am on the "food" topic page
  Then I should see a message with the content "orange"
  And I should not see a message with the content "shirt"

Scenario: Browsing paginated messages on a topic
  Given a topic exists with a title of "BDD"
  And 3 messages exist in a "BDD" topic
  Then I should see 2 messages per page on a topic "BDD"
