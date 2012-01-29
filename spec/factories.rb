require 'factory_girl'

Factory.define :user do |user|
  user.sequence(:name) {|i| "Test User #{i}" }
  user.sequence(:email) {|i| "user#{i}@test.com" }
  user.password 'please'
end

Factory.define :topic do |topic|
  topic.title 'Making BDD fun!'
end

Factory.define :message do |msg|
  msg.sequence(:content) {|i| "message #{i}" }
  msg.association :topic
  msg.association :user
end
