class CreateUserFeeds < ActiveRecord::Migration
  def change
    create_table :user_feeds do |t|
      t.integer :user_id
      t.integer :feed_id

      t.timestamps null: false
    end
    add_index :user_feeds, :user_id
    add_index :user_feeds, :feed_id
  end
end
