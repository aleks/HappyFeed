class FeedItemRead < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed
  belongs_to :feed_item
end
