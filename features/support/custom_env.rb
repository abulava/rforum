require "factory_girl/step_definitions"
require 'paperclip'

module Paperclip::Interpolations 
  alias_method :orig_attachment, :attachment 
  def attachment(att, style) 
    File.join('cucumber', orig_attachment(att, style))
  end 
end

After do 
  test_dir = File.join(Rails.root.to_s, 'public', 'system', 'cucumber')
  `rm -rf #{test_dir}`  #remove paperclip files
end
