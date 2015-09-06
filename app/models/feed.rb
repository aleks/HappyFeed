class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :feed_items, dependent: :destroy

  validates :feed_url, :group_id, presence: true
  validates :feed_url, uniqueness: { scope: :user_id }
  validate :feed_url_is_reachable

  # before_save do
  #   self.feed_url = discover_feed_url(feed_url.strip)
  # end

  def feed_url_is_reachable
    err = 'Feed URL unreachable or error!'
    begin
      unless Faraday.get(feed_url).status.to_s =~ /^2|^3/
        errors.add(:feed_url, err)
      end
    rescue Exception
      errors.add(:feed_url, err)
    end
  end

  def discover_feed_url
    feeds = Feedbag.find(feed_url)
    feeds.each do |feed|
      return feed if Feedbag.feed?(feed)
    end
  end
end
