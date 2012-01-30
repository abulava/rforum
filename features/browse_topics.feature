Feature: Browse topics
  In order to browse through the topics
  As a visitor
  I want to choose a topic from a topic list and read it

Scenario: Browsing a list of topics
  Given the following user exists:
    | Name |
    | user |
  And the following topics exist:
    | Title        |
    | disscus this |
    | no, this!    | 
  When I am on the home page
  Then I should see "disscus this" listed in a topic list
  And I should see "no, this!" listed in a topic list

Scenario: Reading a topic
  Given the following user exists:
    | Name |
    | user |
  And the following topic exists:
    | Title   |
    | foo bar |
  When I am on the home page
  And I follow "foo bar"
  Then I should see "foo bar" in a page body
  And I should see "foo bar" in a page title
  And I should see a "Home" link
