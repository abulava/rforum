namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    user = User.create!(:name => 'First User',
                        :email => 'user@example.com',
                        :password => 'please',
                        :password_confirmation => 'please')

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
