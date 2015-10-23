require 'rails_helper'

describe User do

  it { should have_and_belong_to_many :feeds }
  it { should have_many(:feed_items).through(:feeds) }
  it { should have_many :feed_item_reads }
  it { should have_many :feed_item_stars }
  it { should have_many :groups }

  it {
    FactoryGirl.create(:user)
    should validate_uniqueness_of :email
  }

  before do
    stub_request(:get, "http://need.computer/posts.atom").to_return(File.new('spec/feed_response_raw.txt'))
    stub_request(:get, "http://example.com/posts.atom").to_return(File.new('spec/feed_response_raw.txt'))
  end

  context 'Feed Reading' do
    before :each do
      @user   = FactoryGirl.create(:user)
      @feed   = FactoryGirl.create(:feed, feed_url: 'http://need.computer/posts.atom')
      @feed_2 = FactoryGirl.create(:feed, feed_url: 'http://example.com/posts.atom')

      @user.subscribe(@feed)
      @user.subscribe(@feed_2)

      # Read Items for first Feed
      @feed.feed_items.first(3).each do |feed_item|
        feed_item.mark_as('read', @user.id)
      end

      # Read Items for second Feed
      @feed_2.feed_items.first(3).each do |feed_item|
        feed_item.mark_as('read', @user.id)
      end
    end

    it 'has read_item_ids' do
      expect(@user.read_item_ids).to eq [1, 2, 3, 19, 20, 21]
    end

    it 'has unread_item_ids' do
      expect(@user.unread_item_ids).to eq [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 22,
                                           23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36]
    end

    it 'knows if an Feed Item is read' do
      expect(@user.item_read?(1)).to eq true
    end

    it 'know if an Feed Item is starred' do
      expect(@user.item_starred?(1)).to eq false
      FeedItem.find(1).mark_as('saved', @user.id)
      expect(@user.item_starred?(1)).to eq true
    end

    it 'can unsubscribe and subscribe to Feeds' do
      expect(@user.feeds.include?(@feed)).to be true
      @user.unsubscribe(@feed)
      expect(@user.feeds.include?(@feed)).to be false
      @user.subscribe(@feed)
      expect(@user.feeds.include?(@feed)).to be true
    end
  end

  context 'as a new User' do

    it 'has a default Group' do
      user = User.create(FactoryGirl.attributes_for(:user))
      first_group = user.groups.first
      expect(first_group.default).to be true
      expect(first_group.title).to eq 'Default Group'
    end

  end

end
