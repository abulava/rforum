# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Category do
  before(:each) do
    @attr = {
      :name => "Example Name"
    }
  end

  it "should create a new instance given valid attributes" do
    Category.create!(@attr)
  end

  it { should have_many(:topics) }

  it "should reject duplicate names" do
    Category.create!(@attr)
    category_with_duplicate_name = Category.new(@attr)
    category_with_duplicate_name.should_not be_valid
  end

  it { should validate_presence_of(:name) }
end
