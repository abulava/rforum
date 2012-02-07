require 'spec_helper'

describe MessagesController do
  before(:each) do
    @topic = Factory(:topic)
    @message = Factory(:message)
  end
  after { response.should redirect_to new_user_session_path }

  describe "deny access to user-only actions when not logged in" do
    it { get :new, :topic_id => @topic }

    it { post :create, :topic_id => @topic, :message => Factory.attributes_for(:message) }

    it { delete :destroy, :topic_id => @topic, :id => @message }
  end
end
