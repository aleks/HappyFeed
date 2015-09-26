class User < ActiveRecord::Base
  has_secure_password

  validates :email, uniqueness: true
  validate :validate_email

  has_many :groups
  has_many :user_feeds
  has_many :feeds, through: :user_feeds
  has_many :feed_items, through: :feeds
  has_many :feed_item_reads
  has_many :feed_item_stars

  after_create :add_default_group

  def read_item_ids(feed_id = nil)
    if feed_id
      feed_item_reads.where(feed_id: feed_id).pluck(:feed_item_id)
    else
      feed_item_reads.pluck(:feed_item_id)
    end
  end

  def unread_item_ids
    if feed_item_reads.empty?
      feed_items.pluck(:id)
    else
      feed_items.where("feed_items.id NOT IN (?)", read_item_ids).pluck(:id)
    end
  end

  def saved_item_ids
    feed_item_stars.map(&:feed_item_id)
  end

  def item_read?(feed_item_id)
    feed_item_reads.find_by(feed_item_id: feed_item_id).present?
  end

  def item_starred?(feed_item_id)
    feed_item_stars.find_by(feed_item_id: feed_item_id).present?
  end

  private

    def add_default_group
      Group.create(user_id: id, title: 'Default Group', default: true)
    end

    def validate_email
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        errors.add(:email, "is not a valid email address!")
      end
    end

end
