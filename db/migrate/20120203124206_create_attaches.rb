class CreateAttaches < ActiveRecord::Migration
  def self.up
    create_table :attaches do |t|
      t.integer :message_id

      t.timestamps
    end
  end

  def self.down
    drop_table :attaches
  end
end
