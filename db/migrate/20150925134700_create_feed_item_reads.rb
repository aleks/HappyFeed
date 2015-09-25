class CreateFeedItemReads < ActiveRecord::Migration
  def change
    create_table :feed_item_reads do |t|
      t.integer :user_id
      t.integer :feed_id
      t.integer :feed_item_id

      t.timestamps null: false
    end
    add_index :feed_item_reads, :user_id
    add_index :feed_item_reads, :feed_id
    add_index :feed_item_reads, :feed_item_id
  end
end
