class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :feed_items

  validates :feed_url, :group_id, presence: true
end
