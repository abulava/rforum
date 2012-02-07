When /^I am on the home page$/ do
  visit root_path
end

Then /^I should see "([^"]*)" listed in a topic list$/ do |title|
  within "table.topics" do
    page.should have_content(title)
  end
end

Then /^I should not see "([^"]*)" listed in a topic list$/ do |title|
  within "table.topics" do
    page.should_not have_content(title)
  end
end

When /^I follow "([^"]*)" in a topic list$/ do |title|
  within "table.topics" do
    click_link(title)
  end
end

When /^I am on the "([^"]*)" topic page$/ do |title|
  topic = Topic.find_by_title(title)
  visit topic_path(topic)
end

Then /^I should see a message with the content "([^"]*)"$/ do |content|
  within ".messages" do
    page.should have_content(content)
  end
end

Then /^I should not see a message with the content "([^"]*)"$/ do |content|
  within ".messages" do
    page.should_not have_content(content)
  end
end

Given /^I am signed\-in as a user "([^"]*)"$/ do |user_name|
  user = User.find_by_name(user_name)
  user.should_not be_blank

  visit root_path
  click_link('Login')
  fill_in('Email', :with => user.email)
  fill_in('Password', :with => 'please')
  click_button('Sign in')
end

Given /^I am signed\-in as a user$/ do
  user = User.first
  user.should_not be_blank

  steps %Q{
    Given I am signed-in as a user "#{user.name}"
  }
end

Given /^I am signed\-out$/ do
  visit destroy_user_session_path
end

Then /^I should be on the "([^"]*)" topic page$/ do |title|
  within "title" do
    page.should have_content(title)
  end

  within "table.topic h1" do
    page.should have_content(title)
  end

  topic = Topic.find_by_title(title)
  current_path.should == topic_path(topic)
end

Then /^a message containing "([^"]*)" should be in a topic titled "([^"]*)"$/ do |message_content, topic_title|
  steps %Q{
    When I am on the "#{topic_title}" topic page
    Then I should see a message with the content "#{message_content}"
  }
end

Then /^I should see an error explanation "([^"]*)"$/ do |error|
  find('#error_explanation').find('ul').should have_content(error)
end

Then /^I should see a value "([^"]*)" in a field "([^"]*)"$/ do |value, field|
  find_field(field).value.should == value
end

When /^I post a message containing "([^"]*)" to a topic titled "([^"]*)"$/ do |message_content, topic_title|
  steps %Q{
    When I visit a new message page in a topic titled "#{topic_title}"
  }

  fill_in('Content', :with => message_content)
  click_button('Submit')
end

When /^I post a message with attaches to a topic titled "([^"]*)"$/ do |topic_title|
  steps %Q{
    When I visit a new message page in a topic titled "#{topic_title}"
  }

  fill_in('Content', :with => "with attaches")
  attach_file('message_attaches_attributes_0_data',
              File.join(Rails.root.to_s, 'features', 'upload_files', 'cucumber.jpg'))
  click_button('Submit')
end

Then /^I should see a message with attaches in a topic titled "([^"]*)"$/ do |topic_title|
  steps %Q{
    When I am on the "#{topic_title}" topic page
  }

  message = Message.find_by_content("with attaches")
  within ".messages #message_#{message.id} .attaches" do
    page.should have_link ("cucumber.jpg")
  end
end

When /^I visit a new message page in a topic titled "([^"]*)"$/ do |topic_title|
  click_link('Post reply')

  topic = Topic.find_by_title(topic_title)
  topic.should_not be_blank

  current_path.should == new_topic_message_path(topic)

  within "title" do
    page.should have_content(topic_title)
  end

  within "section h2" do
    page.should have_content(topic_title)
  end
end

Then /^I should see a message "([^"]*)" posted by a user "([^"]*)"$/ do |message_content, user_name|
  message = Message.find_by_content(message_content)
  within ".messages #message_#{message.id}" do
    page.should have_content(message_content)
    page.should have_content("Posted by #{user_name}")
  end
end

Then /^I should not add an invalid message in a topic titled "([^"]*)"$/ do |topic_title|
  short_content = "no"

  steps %Q{
    When I am on the "#{topic_title}" topic page
    And I post a message containing "#{short_content}" to a topic titled "#{topic_title}"
    Then I should see an error explanation "Content is too short"
  }

  topic = Topic.find_by_title(topic_title)
  current_path.should == topic_messages_path(topic)

  within "form#new_message" do
    page.should have_content(short_content)
  end

  steps %Q{
    When I am on the "#{topic_title}" topic page
    Then I should not see a message with the content "#{short_content}"
  }
end

Then /^I cannot delete "([^"]*)" message$/ do |content|
  message = Message.find_by_content content
  page.should have_content(message.content)
  within ".messages #message_#{message.id}" do
    page.should_not have_link('Delete message')
  end
  page.driver.delete topic_message_path(message.topic, message.id)

  steps %Q{
    When I am on the "#{message.topic.title}" topic page
    Then I should see a message with the content "#{content}"
  }
end

Then /^I delete "([^"]*)" message with a flash notification "([^"]*)"$/ do |content, flash_message|
  message = Message.find_by_content content
  page.should have_content(message.content)
  within ".messages #message_#{message.id}" do
    click_on "Delete message"
  end

  steps %Q{
    Then I should see a notification message "#{flash_message}"
    When I am on the "#{message.topic.title}" topic page
    Then I should not see a message with the content "#{content}"
  }
end

Then /^I add a "([^"]*)" topic with a "([^"]*)" message$/ do |topic_title, message_content|
  within ".topics" do
   page.should_not have_content(topic_title)
  end

  within "header nav" do
    click_on "Add topic"
  end
  current_path.should == new_topic_path
  fill_in('Title', :with => topic_title)
  fill_in('Content', :with => message_content)
  click_button('Submit')

  steps %Q{
    Then I should see a notification message "created"
    When I am on the home page
    Then I should see "#{topic_title}" listed in a topic list
    And a message containing "starting" should be in a topic titled "something new"
  }
end

Then /^I should see a notification message "([^"]*)"$/ do |flash_message|
  within "#flash_notice" do
    page.should have_content(flash_message)
  end
end

Then /^I should not add a topic with a too short title$/ do
  short_title = "1"

  within "header nav" do
    click_on "Add topic"
  end
  current_path.should == new_topic_path
  fill_in('Title', :with => short_title)
  click_button('Submit')

  current_path.should == topics_path
  within "form#new_topic" do
    page.should have_content(short_title)
  end
  steps %Q{
    Then I should see an error explanation "too short"
    When I am on the home page
    Then I should not see "#{short_title}" listed in a topic list
  }
end

Then /^I could delete "([^"]*)" topic$/ do |topic_title|
  steps %Q{
    Then I should see "#{topic_title}" listed in a topic list
  }
  
  topic = Topic.find_by_title(topic_title)

  within "table.topics #topic_#{topic.id}" do
    click_on "Delete topic"
  end

  page.current_path.should == topics_path

  steps %Q{
    When I am on the home page
    Then I should not see "#{topic_title}" listed in a topic list
  }
end

Then /^I could not delete "([^"]*)" topic$/ do |topic_title|
  steps %Q{
    Then I should see "#{topic_title}" listed in a topic list
  }

  topic = Topic.find_by_title(topic_title)

  within "table.topics #topic_#{topic.id}" do
    page.should_not have_link("Delete topic")
  end

  page.driver.delete topic_path(topic, topic.id)

  steps %Q{
    When I am on the home page
    Then I should see "#{topic_title}" listed in a topic list
  }
end

Given /^(\d+) messages exist in a "([^"]*)" topic$/ do |total_messages, topic_title|
  topic = Topic.find_by_title(topic_title)
  topic.should_not be_blank

  total_messages.to_i.times do |n|
    Factory(:message, :topic_id => topic.id, :content => "message #{n+1}")
  end
end

Then /^I should see (\d+) messages per page on a topic "([^"]*)"$/ do |test_per_page, topic_title|
  normal_per_page = Message.per_page
  Message.per_page = test_per_page

  steps %Q{
    When I am on the "#{topic_title}" topic page
    Then I should see a message with the content "message 1"
    And I should see a message with the content "message #{test_per_page}"
    And I should not see a message with the content "message #{test_per_page.next}"
  }

  within ".pagination" do
    click_on "Next"
  end

  steps %Q{
    Then I should see a message with the content "message #{test_per_page.next}"
  }

  Message.per_page = normal_per_page
end
