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

require 'spec_helper'

describe Attach do
  it { should belong_to(:message) }

  it { should have_attached_file(:data) }

  it { should validate_attachment_size(:data).less_than 1.megabyte }
end
