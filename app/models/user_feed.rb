class UserFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :feed

  validates :feed_id, uniqueness: { scope: :user_id }
end
