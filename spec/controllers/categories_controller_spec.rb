require 'spec_helper'

describe CategoriesController do
  describe "deny access to user-only actions when not logged in" do
    before(:each) do
      @category = Factory(:category)
    end
    after { response.should redirect_to new_user_session_path }

    it { get :index }

    it { get :new }

    it { post :create, :category => Factory.attributes_for(:category) }

    it { get :edit, :id => @category }

    it { put :update, :id => @category, :category => Factory.attributes_for(:category) }

    it { delete :destroy, :id => @category }
  end
end
