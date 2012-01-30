class AddUserIdToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :user_id, :integer
    add_index :topics, :user_id
  end

  def self.down
    remove_index :topics, :user_id
    remove_column :topics, :user_id
  end
end
