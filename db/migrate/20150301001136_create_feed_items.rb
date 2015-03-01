class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.integer :feed_id
      t.string :title
      t.string :author
      t.string :html
      t.string :url
      t.boolean :is_saved
      t.boolean :is_read
      t.datetime :created_on_time
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
