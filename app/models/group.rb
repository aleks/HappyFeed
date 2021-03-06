class Group < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :feeds
  has_many :feed_items, through: :feeds

  before_destroy :add_feeds_to_default_group

  def add_feed(feed)
    feeds << feed
  end

  def remove_feed(feed)
    feeds.delete(feed)
  end

  def add_feeds_to_default_group
    default_group = User.find(user_id).groups.find_by(default: true)

    feeds.each do |feed|
      default_group.add_feed(feed)
    end
  end
end
