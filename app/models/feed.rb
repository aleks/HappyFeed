class Feed < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :feed_items, dependent: :destroy
  has_many :feed_item_reads, dependent: :destroy
  has_and_belongs_to_many :groups

  validates :feed_url, presence: true
  validates :feed_url, uniqueness: true
  validate :feed_url_is_reachable

  # before_save :discover_feed_url
  after_create :fetch_feed

  def unread_items(user_id)
    reads = User.find(user_id).read_item_ids(id)
    if reads.empty?
      feed_items
    else
      feed_items.where("feed_items.id NOT IN (?)", reads)
    end
  end

  private

    def fetch_feed
      FeedFetcher.new(id).fetch
    end

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

    # def discover_feed_url
    #   feeds = Feedbag.find(feed_url)
    #   feeds.each do |feed_url|
    #     self.feed_url = feed_url if Feedbag.feed?(feed_url)
    #   end
    # end
end
