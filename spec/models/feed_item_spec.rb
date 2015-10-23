require 'rails_helper'

describe FeedItem do

  it { should belong_to :feed }
  it { should have_many :feed_item_reads }
  it { should have_many :feed_item_stars }

  it { should validate_presence_of :feed_id }
  it { should validate_presence_of :title }

  before do
    stub_request(:get, "http://need.computer/posts.atom").to_return(File.new('spec/feed_response_raw.txt'))
  end

  context "FeedItem marking" do
    before :each do
      @user = FactoryGirl.create(:user)
      @feed = FactoryGirl.create(:feed, feed_url: 'http://need.computer/posts.atom')
    end

    it 'can mark Feed Items as read and unread' do
      feed_item = @feed.feed_items.first

      feed_item.mark_as('read', @user.id)
      expect(FeedItemRead.where(feed_item_id: feed_item.id).present?).to be true
      expect(@user.item_read?(feed_item.id)).to be true

      feed_item.mark_as('unread', @user.id)
      expect(FeedItemRead.where(feed_item_id: feed_item.id).present?).to be false
      expect(@user.item_read?(feed_item.id)).to be false
    end

    it 'can mark Feed Items as stared and unstared' do
      feed_item = @feed.feed_items.first

      feed_item.mark_as('saved', @user.id)
      expect(FeedItemStar.where(feed_item_id: feed_item.id).present?).to be true
      expect(@user.item_starred?(feed_item.id)).to be true

      feed_item.mark_as('unsaved', @user.id)
      expect(FeedItemStar.where(feed_item_id: feed_item.id).present?).to be false
      expect(@user.item_starred?(feed_item.id)).to be false
    end
  end

  context "FeedItem methods" do
    before :each do
      @feed = FactoryGirl.create(:feed, feed_url: 'http://need.computer/posts.atom')
    end

    it 'can return the next and previous Feed Item' do
      collected_items = []
      feed_items = @feed.feed_items
      feed_items.each do |feed_item|
        collected_items << feed_item
      end

      expect(feed_items[0].next_item).to eq collected_items[1]
      expect(feed_items[0].previous_item).to eq nil

      expect(feed_items[1].next_item).to eq collected_items[2]
      expect(feed_items[1].previous_item).to eq collected_items[0]

      expect(feed_items[2].next_item).to eq collected_items[3]
      expect(feed_items[2].previous_item).to eq collected_items[1]
    end

  end

end
