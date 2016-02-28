class FeedFetcherJob < ActiveJob::Base
  queue_as :default

  def perform(feed_id)
    ActiveRecord::Base.connection_pool.with_connection do
      FeedFetcher.new(feed_id).fetch
    end
  end
end
