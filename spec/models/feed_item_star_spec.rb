require 'rails_helper'

describe FeedItemStar do

  it { should belong_to :user }
  it { should belong_to :feed }
  it { should belong_to :feed_item }

end
