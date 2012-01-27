require 'spec_helper'

describe MessagesController do
  render_views

  before(:each) do
    @topic = Factory(:topic)
    @attr = { :content => "lorem ipsum" }
  end

  describe "access control" do

    it "should deny access to 'new'" do
      post :new, :topic_id => @topic
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'create'" do
      post :create, :topic_id => @topic
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1, :topic_id => @topic
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'new'" do
    before { login_user }

    it "should be successful" do
      get :new, :topic_id => @topic
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before { login_user }

#    it "should redirect to the topic page" do
#      post :create, :micropost => @attr, :topic_id => @topic
#      response.should redirect_to(topic_path(@topic))
#    end

    it "should create a message" do
      lambda do
        post :create, :message => @attr, :topic_id => @topic
      end.should change(Message, :count).by(1)
    end
  end
end
