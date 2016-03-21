class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.integer :feed_id
      t.string :title
      t.string :author
      t.text :html
      t.string :url
      t.datetime :created_on_time

      t.timestamps null: false
    end
  end
end
