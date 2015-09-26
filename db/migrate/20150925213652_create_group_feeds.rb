class CreateGroupFeeds < ActiveRecord::Migration
  def change
    create_table :group_feeds do |t|
      t.integer :group_id
      t.integer :feed_id

      t.timestamps null: false
    end
    add_index :group_feeds, :group_id
    add_index :group_feeds, :feed_id
  end
end
