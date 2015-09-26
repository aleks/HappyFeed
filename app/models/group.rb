class Group < ActiveRecord::Base
  belongs_to :user
  has_many :group_feeds, dependent: :destroy
  has_many :feeds, through: :group_feeds
  has_many :feed_items, through: :feeds

  before_destroy :add_feeds_to_default_group

  def add_feed(feed_id)
    group_feeds.create(feed_id: feed_id)
  end

  def remove_feed(feed_id)
    group_feeds.find_by(feed_id: feed_id).destroy
  end

  def add_feeds_to_default_group
    default_group_id = User.find(user_id).groups.find_by(default: true).id

    feeds.each do |feed|
      GroupFeed.create(group_id: default_group_id, feed_id: feed.id)
    end
  end
end
