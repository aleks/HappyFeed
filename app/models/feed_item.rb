class FeedItem < ActiveRecord::Base
  belongs_to :feed

  validates :feed_id, :title, :url, presence: true
end
