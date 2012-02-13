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
  validate :content_as_bbcode

  scope :created_in_recent_days, lambda { |v| where(:created_at.gt => v.days.ago) }
  scope :sort_by_created_at_asc, order('created_at ASC')

  search_methods :created_in_recent_days, :splat_param => true, :type => :integer

  self.per_page = 5

  def self.created_in_recent_days_options
    [['day',      '1'],
     ['3 days',   '3'],
     ['week',     '7'],
     ['30 days', '30']]
  end

  def self.search(params = nil)
    if params.nil?
      super
    else
      new_params = { 'meta_sort' => 'created_at.desc' }.merge params
      super(new_params)
    end
  end

  private
    def content_as_bbcode
      if content
        result = content.is_valid_bbcode?
        unless result == true
          errors.add(:content, result)
        end
      end
    end
end
