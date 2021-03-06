require 'factory_girl'

Factory.define :user do |user|
  user.sequence(:name) { |i| "Test User #{i}" }
  user.sequence(:email) { |i| "user#{i}@test.com" }
  user.password 'please'
end

Factory.define :category do |category|
  category.sequence(:name) { |i| "Category #{i}" }
end

Factory.define :topic do |topic|
  topic.title 'Making BDD fun!'
  topic.association :user
  topic.association :category
end

Factory.define :message do |msg|
  msg.sequence(:content) { |i| "message #{i}" }
  msg.association :topic
  msg.association :user
end
