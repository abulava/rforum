Given /^a topic with the title "([^"]*)"$/ do |title|
  Topic.create!(:title => title)
end

When /^I am on the home page$/ do
  visit root_path
end

Then /^I should see "([^"]*)" listed in a topic list$/ do |title|
  page.should have_selector("table.topics tr td", :text => title)
end

When /^I follow "([^"]*)"$/ do |title|
  click_link(title)
end

Then /^I should see "([^"]*)" in a page body$/ do |title|
  page.should have_selector("table.topic h1", :text => title)
end

Then /^I should see "([^"]*)" in a page title$/ do |title|
  page.should have_selector("title", :text => title)
end

Then /^I should see a "([^"]*)" link$/ do |topics_link|
  page.should have_link(topics_link, :href => topics_path)
end

When /^I am on the "([^"]*)" topic page$/ do |title|
  topic = Topic.find_by_title(title)
  visit topic_path(topic)
end

Then /^I should see a message with the content "([^"]*)"$/ do |content|
  page.should have_content(content)
end

Then /^I should not see a message with the content "([^"]*)"$/ do |content|
  page.should_not have_content(content)
end

Given /^I am signed\-in as a user "([^"]*)"$/ do |user_name|
  user = Factory(:user, :name => user_name)
  visit root_path
  click_link('Login')
  fill_in('Email', :with => user.email)
  fill_in('Password', :with => user.password)
  click_button('Sign in')
end

Then /^I should be on the "([^"]*)" topic page$/ do |title|
  topic = Topic.find_by_title(title)
  current_path.should == topic_path(topic)
end

Then /^a message containing "([^"]*)" should be in a topic titled "([^"]*)"$/ do |message_content, topic_title|
  topic = Topic.find_by_title(topic_title)
  message = Message.find_by_content(message_content)

  visit topic_path(topic)
  within ".messages #message_#{message.id}" do
    page.should have_content(message_content)
  end
end

Then /^I should be on the new message page in a topic titled "([^"]*)"$/ do |title|
  topic = Topic.find_by_title(title)
  current_path.should == topic_messages_path(topic)
end

Then /^I should see an error explanation "([^"]*)"$/ do |error|
  find('#error_explanation').find('ul').should have_content(error)
end

Then /^I should see a value "([^"]*)" in a field "([^"]*)"$/ do |value, field|
  find_field(field).value.should == value
end

When /^I am posted a message containing "([^"]*)"$/ do |message_content|
  click_link('Post reply')
  fill_in('Content', :with => message_content)
  click_button('Submit')
end

Then /^I should see a message "([^"]*)" posted by a user "([^"]*)"$/ do |message_content, user_name|
  page.should have_content(message_content)
  page.should have_content("Posted by #{user_name}")
end

Then /^I should not see a message "([^"]*)" posted by a user "([^"]*)"$/ do |message_content, user_name|
  page.should_not have_content(message_content)
  page.should_not have_content("Posted by #{user_name}")
end

Then /^I cannot delete "([^"]*)" message$/ do |content|
  message = Message.find_by_content content
  page.should have_content(message.content)
  within ".messages #message_#{message.id}" do
    page.should_not have_link('Delete message')
  end
end

Then /^I delete "([^"]*)" message with a notification message "([^"]*)"$/ do |content, flash_message|
  message = Message.find_by_content content
  page.should have_content(message.content)
  within ".messages #message_#{message.id}" do
    click_on "Delete message"
  end
  page.should have_content(flash_message)
  visit topic_path(message.topic)
  page.should_not have_content(content)
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

  current_path.should == root_path
  within ".topics" do
    page.should have_content(topic_title)
  end
end

Then /^I should see a notification message "([^"]*)"$/ do |flash_message|
  within "#flash_notice" do
    page.should have_content(flash_message)
  end
end

Then /^I should not add a topic with a too short title$/ do
  visit root_path
  within ".topics" do
    page.should_not have_content("1")
  end

  within "header nav" do
    click_on "Add topic"
  end
  current_path.should == new_topic_path
  fill_in('Title', :with => "1")
  click_button('Submit')

  current_path.should == topics_path
  within "form#new_topic" do
    page.should have_content("1")
  end
end
