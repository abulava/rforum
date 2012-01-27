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

When /I am on the topic "([^"]*)" page$/ do |title|
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

Given /^I fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^I press "([^"]*)"$/ do |name|
  click_button(name)
end

Then /^I should be on the page showing a topic with the title "([^"]*)"$/ do |title|
  topic = Topic.find_by_title(title)
  current_path.should == topic_path(topic)
end

Then /^a message containing "([^"]*)" should be in a topic titled "([^"]*)"$/ do |message_content, topic_title|
  Message.find_by_content(message_content).topic.title.should == topic_title
end

Then /^I should be on the new message page in a topic titled "([^"]*)"$/ do |title|
  topic = Topic.find_by_title(title)
  current_path.should == topic_messages_path(topic)
end

Then /^I shoud see an error explanation "([^"]*)"$/ do |error|
  find('#error_explanation').find('ul').should have_content(error)
end

Then /^I should see a value "([^"]*)" in a field "([^"]*)"$/ do |value, field|
  find_field(field).value.should == value
end

Then /^I cannot delete "([^"]*)" message$/ do |content|
   pending
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



