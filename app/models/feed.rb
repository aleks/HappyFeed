class Feed < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :feed_items, dependent: :destroy
  has_many :feed_item_reads, dependent: :destroy
  has_many :feed_item_stars, dependent: :destroy
  has_and_belongs_to_many :groups

  validates :feed_url, presence: true
  validates :feed_url, uniqueness: true
  validate :feed_url_is_reachable

  after_create :fetch_feed

  # we need the group_id for our modal subscription dialog
  attr_accessor :group_id

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
      FeedFetcherJob.perform_later(id)
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

end
