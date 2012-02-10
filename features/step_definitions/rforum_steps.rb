def visit_home_page
  visit root_path
end

def visit_topic_page_with_title_of(title)
  topic = Topic.find_by_title(title)
  visit topic_path(topic)
end

def within_flash_notice(&block)
  within("#flash_notice", &block)
end

def within_error_explanation(&block)
  within("#error_explanation ul", &block)
end

def within_topics_list(&block)
  within("table.topics", &block)
end

def within_messages_list(&block)
  within(".messages", &block)
end

def sign_in_user(user_name)
  user = User.find_by_name(user_name)
  user.should_not be_blank

  visit root_path
  click_link('Login')
  fill_in('Email', :with => user.email)
  fill_in('Password', :with => 'please')
  click_button('Sign in')
end

def visit_new_topic_message_page_of(topic_title)
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

def update_topic_title(topic_title, new_topic_title)
  topic = Topic.find_by_title(topic_title)

  within "table.topics #topic_#{topic.id}" do
    page.click_on('Edit topic')
  end

  page.current_path.should == edit_topic_path(topic)
  fill_in('Title', :with => new_topic_title)
  click_button('Submit')
end

Then /^I should see a message with the content "([^"]*)"$/ do |content|
  within_messages_list do
    page.should have_content(content)
  end
end

When /^I am on the home page$/ do
  visit_home_page
end

Then /^I should see "([^"]*)" listed in a topic list$/ do |title|
  within_topics_list do
    page.should have_content(title)
  end
end

Then /^I should not see "([^"]*)" listed in a topic list$/ do |title|
  within_topics_list do
    page.should_not have_content(title)
  end
end

When /^I follow "([^"]*)" in a topic list$/ do |title|
  within_topics_list do
    click_link(title)
  end
end

When /^I am on the "([^"]*)" topic page$/ do |topic_title|
  visit_topic_page_with_title_of topic_title
end

Then /^I should not see a message with the content "([^"]*)"$/ do |content|
  within_messages_list do
    page.should_not have_content(content)
  end
end

Given /^I am signed\-in as a user "([^"]*)"$/ do |user_name|
  sign_in_user user_name
end

Given /^I am signed\-in as a user$/ do
  sign_in_user User.first.name
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
  visit_topic_page_with_title_of topic_title
  within_messages_list do
    page.should have_content(message_content)
  end
end

def create_topic_message(message_content, topic_title)
  visit_new_topic_message_page_of topic_title

  fill_in('Content', :with => message_content)
  click_button('Submit')
end

When /^I post a message containing "([^"]*)" to a topic titled "([^"]*)"$/ do |message_content, topic_title|
  create_topic_message message_content, topic_title
end

When /^I post a message with attaches to a topic titled "([^"]*)"$/ do |topic_title|
  visit_new_topic_message_page_of topic_title

  fill_in('Content', :with => "with attaches")
  attach_file('message_attaches_attributes_0_data',
              File.join(Rails.root.to_s, 'features', 'upload_files', 'cucumber.jpg'))
  click_button('Submit')
end

Then /^I should see a message with attaches in a topic titled "([^"]*)"$/ do |topic_title|
  visit_topic_page_with_title_of topic_title

  message = Message.find_by_content("with attaches")
  within ".messages #message_#{message.id} .attaches" do
    page.should have_link ("cucumber.jpg")
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

  visit_topic_page_with_title_of topic_title

  create_topic_message short_content, topic_title

  within_error_explanation do
    page.should have_content("Content is too short")
  end

  topic = Topic.find_by_title(topic_title)
  current_path.should == topic_messages_path(topic)

  within "form#new_message" do
    page.should have_content(short_content)
  end

  visit_topic_page_with_title_of topic_title
  within_messages_list do
    page.should_not have_content(short_content)
  end
end

Then /^I cannot delete "([^"]*)" message$/ do |content|
  message = Message.find_by_content content
  within_messages_list do
    page.should have_content(content)
  end

  within ".messages #message_#{message.id}" do
    page.should_not have_link('Delete message')
  end

  page.driver.delete topic_message_path(message.topic, message.id)

  visit_topic_page_with_title_of message.topic.title
  within_messages_list do
    page.should have_content(content)
  end
end

Then /^I delete "([^"]*)" message with a flash notification "([^"]*)"$/ do |content, flash_message|
  message = Message.find_by_content content
  page.should have_content(message.content)
  within ".messages #message_#{message.id}" do
    click_on "Delete message"
  end

  within_flash_notice do
    page.should have_content(flash_message)
  end

  visit_topic_page_with_title_of message.topic.title
  within_messages_list do
    page.should_not have_content(content)
  end
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

  within_flash_notice do
    page.should have_content("created")
  end

  visit_home_page

  within_topics_list do
    page.should have_content(topic_title)
  end

  visit_topic_page_with_title_of topic_title
  within_messages_list do
    page.should have_content(message_content)
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

  within_error_explanation do
    page.should have_content("too short")
  end

  visit_home_page

  within_topics_list do
    page.should_not have_content(short_title)
  end
end

Then /^I could delete "([^"]*)" topic$/ do |topic_title|
  within_topics_list do
    page.should have_content(topic_title)
  end
  
  topic = Topic.find_by_title(topic_title)

  within "table.topics #topic_#{topic.id}" do
    click_on "Delete topic"
  end

  page.current_path.should == topics_path

  visit_home_page

  within_topics_list do
    page.should_not have_content(topic_title)
  end
end

Then /^I could not delete "([^"]*)" topic$/ do |topic_title|
  within_topics_list do
    page.should have_content(topic_title)
  end

  topic = Topic.find_by_title(topic_title)

  within "table.topics #topic_#{topic.id}" do
    page.should_not have_link("Delete topic")
  end

  page.driver.delete topic_path(topic, topic.id)

  visit_home_page

  within_topics_list do
    page.should have_content(topic_title)
  end
end

Then /^I could change "([^"]*)" topic title to "([^"]*)"$/ do |topic_title, new_topic_title|
  within_topics_list do
    page.should have_content(topic_title)
  end

  update_topic_title topic_title, new_topic_title

  within_flash_notice do
    page.should have_content("updated")
  end

  visit_home_page

  within_topics_list do
    page.should_not have_content(topic_title)
  end

  within_topics_list do
    page.should have_content(new_topic_title)
  end
end

Then /^I could not violate access changing "([^"]*)" topic title to "([^"]*)"$/ do |topic_title, new_topic_title|
  within_topics_list do
    page.should have_content(topic_title)
  end

  topic = Topic.find_by_title(topic_title)

  within "table.topics #topic_#{topic.id}" do
    page.should_not have_link('Edit topic')
  end

  page.driver.put topic_path(topic, :topic => Factory.attributes_for(:topic).merge(:title => new_topic_title))

  visit_home_page

  within_topics_list do
    page.should have_content(topic_title)
  end
end

Then /^I could not change "([^"]*)" topic title to "([^"]*)"$/ do |topic_title, new_topic_title|
  within_topics_list do
    page.should have_content(topic_title)
  end

  update_topic_title topic_title, new_topic_title

  within_error_explanation do
    page.should have_content("too short")
  end

  find_field("Title").value.should == new_topic_title

  visit_home_page

  within_topics_list do
    page.should_not have_content(new_topic_title)
  end
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

  visit_topic_page_with_title_of topic_title

  within_messages_list do
    page.should have_content("message 1")
    page.should have_content("message #{test_per_page}")
    page.should_not have_content("message #{test_per_page.next}")
  end

  within ".pagination" do
    click_on "Next"
  end

  within_messages_list do
    page.should have_content("message #{test_per_page.next}")
  end

  Message.per_page = normal_per_page
end
