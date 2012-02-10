class AddCategoryIdToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :category_id, :integer
    add_index :topics, :category_id
  end

  def self.down
    remove_index :topics, :category_id
    remove_column :topics, :category_id
  end
end
