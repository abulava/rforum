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

  it { should have_many(:attaches) }

  describe "validations of a new instance belonging to a topic" do
    before(:each) do
      @message = @topic.messages.new(@attr)
    end
  
    subject { @message }

    it { should ensure_length_of(:content).
                  is_at_least(3).
                  is_at_most(1000) }
  end
end
