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

class Topic < ActiveRecord::Base
  attr_accessible :title, :messages_attributes

  belongs_to :user
  has_many :messages

  validates_presence_of :user_id
  validates :title, :length => { :minimum => 3, :maximum => 140 }

  accepts_nested_attributes_for :messages
end
