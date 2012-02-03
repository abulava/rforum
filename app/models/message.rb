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

class Message < ActiveRecord::Base
  attr_accessible :content, :attaches_attributes

  belongs_to :topic
  belongs_to :user

  has_many :attaches, :dependent => :destroy

  accepts_nested_attributes_for :attaches

  validates_presence_of :user_id
  validates :content, :length => { :minimum => 3, :maximum => 1000 }

  default_scope :order => 'messages.created_at ASC'

  self.per_page = 5
end
