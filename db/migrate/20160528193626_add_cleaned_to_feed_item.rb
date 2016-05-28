class AddCleanedToFeedItem < ActiveRecord::Migration
  def change
    add_column :feed_items, :cleaned, :boolean, default: false
  end
end
