# == Schema Information
#
# Table name: attaches
#
#  id                :integer         not null, primary key
#  message_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  data_file_name    :string(255)
#  data_content_type :string(255)
#  data_file_size    :integer
#  data_updated_at   :datetime
#

class Attach < ActiveRecord::Base
  belongs_to :message
  
  has_attached_file :data
end
