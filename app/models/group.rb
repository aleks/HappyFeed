class Group < ActiveRecord::Base
  belongs_to :user
  has_many :feeds

  before_destroy :add_feeds_to_default_group

  def add_feeds_to_default_group
    feeds.each {|f| f.update_attribute(:group_id, User.find(user_id).groups.find_by(default: true).id)}
  end
end
