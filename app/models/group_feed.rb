class GroupFeed < ActiveRecord::Base
  belongs_to :group
  belongs_to :feed
end
