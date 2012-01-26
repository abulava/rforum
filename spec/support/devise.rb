RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = Factory(:user)
      sign_in user
    end
  end
end