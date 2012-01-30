require 'spec_helper'

describe TopicsController do
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @topic = Factory(:topic)
    end

    it "should be successful" do
      get :show, :id => @topic
      response.should be_success
    end
  end


  describe "access control" do

    it "should deny access to 'new' for guests" do
      post :new
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'create' for guests" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy' for guests" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end
end
