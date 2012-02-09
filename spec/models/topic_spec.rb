# == Schema Information
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'spec_helper'

describe Topic do
  def add_message_to(topic)
    topic.messages.
          build(Factory.attributes_for(:message)).save(:validate => false)
  end

  before(:each) do
    @user = Factory(:user)
    @attr = {
      :title => "Example Title"
    }
  end

  it "should should create a new instance given valid attributes" do
    topic = @user.topics.create!(@attr)
  end

  it { should have_many(:messages).dependent(:destroy) }

  it { should_not allow_mass_assignment_of(:user_id) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }

  describe "message association" do
    before(:each) do
      @topic = @user.topics.create!(@attr)
    end

    it "should have the right messages in the right order" do
      msg1 = Factory(:message, :topic => @topic, :created_at => 1.hour.ago)
      msg2 = Factory(:message, :topic => @topic, :created_at => 1.day.ago)

      @topic.messages.should == [msg2, msg1]
    end

    it "should return proper messages.total_pages" do
      @topic.messages.total_pages.should == 0

      add_message_to @topic
      @topic.messages.total_pages.should == 1

      (Message.per_page-1).times do 
        add_message_to @topic
      end
      @topic.messages.total_pages.should == 1

      add_message_to @topic
      @topic.messages.total_pages.should == 2
    end

    it "should respond to messages.single_message?" do
      @topic.messages.single_message?.should be_false
  
      add_message_to @topic
      @topic.messages.single_message?.should be_true
  
      add_message_to @topic
      @topic.messages.single_message?.should be_false
    end
  end

  it "should return all topics ordered by the date of the newest message" do
      topic1 = @user.topics.create!(@attr.merge :title => "topic1")
      Factory(:message, :topic => topic1, :created_at => 1.hour.ago)

      topic2 = @user.topics.create!(@attr.merge :title => "topic2")
      Factory(:message, :topic => topic2, :created_at => 1.day.ago)

      Topic.all_by_newest_message.should == [topic1, topic2]

      Factory(:message, :topic => topic2, :created_at => 59.minutes.ago)

      Topic.all_by_newest_message.should == [topic2, topic1]
  end

  describe "validations" do
    before(:each) do
      @topic = @user.topics.new(@attr)
    end

    subject { @topic }

    it { should ensure_length_of(:title).
                  is_at_least(3).
                  is_at_most(140) }
  end
end
