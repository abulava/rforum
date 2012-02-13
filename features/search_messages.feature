Feature: Search messages
  In order to browse specific messages satisfying given search criteria
  As a visitor
  I want to be able to choose search criteria and browse search results

Scenario: Opening a search form
  Given a message exists with a content of "empty search results initially"
  And I am on the home page
  When I follow a search link
  Then I should not see a message with the content "empty search results initially"
  And I should see a search form

Scenario: Searching by message content
  Given a message exists with a content of "should be found"
  And a message exists with a content of "not found"
  And I am on the search page
  When I search by message content of "be found"
  Then I should see a message with the content "be found"
  And I should not see a message with the content "not found"

Scenario: Searching by message's topic
  Given the following messages exist:
    | Content         | Topic               |
    | should be found | Title: search me    |
    | not found	      | Title: not searched |
  And I am on the search page
  When I search by message's topic "search me"
  Then I should see a message with the content "be found"
  And I should not see a message with the content "not found"

Scenario: Searching by recent messages
  Given the following messages with mangled creation time exist
    | content           | created_at |
    | less than day old | 1.hour.ago |
    | two days old      | 2.days.ago |
  And I am on the search page
  When I search by messages created in recent "day"
  Then I should see a message with the content "less than day"
  And I should not see a message with the content "two days"

Scenario: Searching by category of message's topic
  Given the following topics exist:
   | Title  | Category           |
   | topic1 | Name: searched1    |
   | topic2 | Name: searched2    |
   | topic3 | Name: not searched |
  And the following messages exist:
   | Content   | Topic         |
   | message1  | Title: topic1 |
   | message2  | Title: topic2 |
   | not found | Title: topic3 |
  And I am on the search page
  When I search by "searched1" and "searched2" categories
  Then I should see a message with the content "message1"
  And I should see a message with the content "message2"
  And I should not see a message with the content "not found"

Scenario: Searching by message's author
  Given the following messages exist:
    | Content         | User       |
    | should be found | Name: John |
    | not found       | Name: Jill |
  And I am on the search page
  When I search by message's author of "John"
  Then I should see a message with the content "be found"
  And I should not see a message with the content "not found"
