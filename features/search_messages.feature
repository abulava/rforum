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
