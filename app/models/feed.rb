class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :feed_url, :group_id, presence: true
end
