class FeedItemJob < ActiveJob::Base
  queue_as :default

  def perform(feed_item_id)
    ActiveRecord::Base.connection_pool.with_connection do
      FeedItem.find(feed_item_id).preload_images
    end
  end
end
