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
  before(:each) do
    @user = Factory(:user)
    @attr = {
      :title => "Example Title"
    }
  end

  it "should should create a new instance given valid attributes" do
    topic = @user.topics.create!(@attr)
  end

  it { should have_many(:messages) }

  it { should_not allow_mass_assignment_of(:user_id) }

  it { should belong_to(:user) }

  it { should validate_presence_of(:user_id) }

  it "should have the right messages in the right order" do
    topic = @user.topics.create!(@attr)
    msg1 = Factory(:message, :topic => topic, :created_at => 1.hour.ago)
    msg2 = Factory(:message, :topic => topic, :created_at => 1.day.ago)

    topic.messages.should == [msg2, msg1]
  end
end
