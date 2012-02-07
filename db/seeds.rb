# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
admin = User.create!(:name     => 'Administrator',
                     :email    => 'admin@example.com',
                     :password => 'please')
admin.toggle!(:admin)
