# == Schema Information
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#  category_id :integer
#

class Topic < ActiveRecord::Base
  attr_accessible :title, :messages_attributes, :category_id

  belongs_to :category
  belongs_to :user
  has_many :messages, :dependent => :destroy do
    def total_pages
      (self.count / Message.per_page.to_f).ceil
    end

    def single_message?
      self.size == 1
    end
  end

  validates_presence_of :user_id
  validates :title, :length => { :minimum => 3, :maximum => 140 }

  accepts_nested_attributes_for :messages

  def self.all_by_newest_message
    self.find(:all,
              :include => :messages,
              :order   => "messages.created_at DESC")
  end
end
