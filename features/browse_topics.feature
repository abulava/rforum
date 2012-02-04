Feature: Browse topics
  In order to browse through the topics
  As a visitor
  I want to choose a topic from a topic list and read it

Scenario: Browsing a list of topics
  Given a topic exists with a title of "discuss this"
  And a topic exists with a title of "no, this!"
  When I am on the home page
  Then I should see "discuss this" listed in a topic list
  And I should see "no, this!" listed in a topic list

Scenario: Reading a topic
  Given a topic exists with a title of "foo bar"
  When I am on the home page
  And I follow "foo bar" in a topic list
  Then I should be on the "foo bar" topic page
