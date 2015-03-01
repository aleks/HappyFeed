class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :feed_items

  validates :feed_url, :group_id, presence: true

  before_create do
    self.feed_url = self.feed_url.strip
  end
end
