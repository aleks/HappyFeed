class CreateFeedItemStars < ActiveRecord::Migration
  def change
    create_table :feed_item_stars do |t|
      t.integer :user_id
      t.integer :feed_id
      t.integer :feed_item_id

      t.timestamps null: false
    end
    add_index :feed_item_stars, :user_id
    add_index :feed_item_stars, :feed_id
    add_index :feed_item_stars, :feed_item_id
  end
end
