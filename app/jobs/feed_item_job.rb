class FeedItemJob < ActiveJob::Base
  queue_as :default

  def perform(feed_item_id)
    ActiveRecord::Base.connection_pool.with_connection do
      FeedFetcher.cleanup_item_content(feed_item_id)
    end
  end
end
