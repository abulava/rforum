require 'spec_helper'

describe TopicsController do
  describe "deny access to user-only actions when not logged in" do
    before(:each) do
      @topic = Factory(:topic)
    end
    after { response.should redirect_to new_user_session_path }

    it { get :new }

    it { post :create, :topic => Factory.attributes_for(:topic) }

    it { get :edit, :id => @topic }

    it { put :update, :id => @topic, :topic => Factory.attributes_for(:topic) }

    it { delete :destroy, :id => @topic }
  end
end
