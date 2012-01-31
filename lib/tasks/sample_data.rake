namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    user_attr = {
                 :password => 'please',
                 :password_confirmation => 'please'
                }

    admin = User.create!(user_attr.merge(
                         :name => 'Admin User',
                         :email => 'admin@example.com'
                        ))
    admin.toggle!(:admin)

    user = User.create!(user_attr.merge(
                        :name => 'Test User',
                        :email => 'user@example.com'
                       ))

    25.times do |n|
      fake = Faker::Lorem.sentence(4)
      title = "Topic #{n+1}: #{fake}"
      topic = user.topics.build(:title => title)
      topic.save!

      msg = topic.messages.build(:content => "Starting topic #{n+1}.")
      msg.user = user
      msg.update_attribute :created_at, 4321.minutes.ago
      msg.save!
    end

    Topic.all(:limit => 6).each do |topic|
      (1 + rand(8)).times do
        msg = topic.messages.build(:content => Faker::Lorem.paragraph(1 + rand(3)))
        msg.user = user
        msg.update_attribute :created_at, rand(4320).minutes.ago
        msg.save!
      end
    end
  end
end
