class AddCleanedToFeedItem < ActiveRecord::Migration
  def change
    add_column :feed_items, :cleaned, :boolean, default: false

    FeedItem.update_all(cleaned: true)
  end
end
