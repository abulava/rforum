# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  content    :text
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Message do
  before(:each) do
    @user = Factory(:user)
    @topic = Factory(:topic)
    @attr = {
      :content  => "Example Content",
    }
  end

  it "should save a new instance given valid attributes" do
    message = @topic.messages.new(@attr)
    message.user = @user
    message.save!
  end

  it { should_not allow_mass_assignment_of(:user_id) }

  it { should_not allow_mass_assignment_of(:topic_id) }

  it { should belong_to(:topic) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }

  it { should have_many(:attaches).dependent(:destroy) }

  describe "validations of a new instance belonging to a topic" do
    before(:each) do
      @message = @topic.messages.new(@attr)
    end
  
    subject { @message }

    it { should ensure_length_of(:content).
                  is_at_least(3).
                  is_at_most(1000) }

    it "should validate content as bb code" do
      @message.valid?

      lambda do
        @message.content = "invalid [b]b code"
        @message.valid?
      end.should change(@message.errors, :length)
    end
  end

  it "should find recent messages" do
    old_message = Factory(:message, :created_at => 8.days.ago)
    recent_message = Factory(:message, :created_at => 1.day.ago)

    Message.created_in_recent_days(7).should == [recent_message]
  end
end
