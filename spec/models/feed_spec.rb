require 'rails_helper'

describe Feed do

  it { should have_and_belong_to_many :users }
  it { should have_and_belong_to_many :groups }
  it { should have_many :feed_items }
  it { should have_many :feed_item_reads }
  it { should have_many :feed_item_stars }

  it { should validate_presence_of :feed_url }
  it {
    FactoryGirl.create(:feed, feed_url: 'http://need.computer/posts.atom')
    should validate_uniqueness_of :feed_url
  }

  before do
    stub_request(:get, "http://need.computer/posts.atom").to_return(File.new('spec/feed_response_raw.txt'))
    stub_request(:get, "http://need.computer/feed_response_image.png")
      .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
      .to_return(status: 200, body: File.new('spec/feed_response_image.png'))
  end


  it 'fetches FeedItems after_create' do
    feed = FactoryGirl.create(:feed, feed_url: 'http://need.computer/posts.atom')
    expect(feed.feed_items.count).to eq 5


  end

  it 'checks if the feed_url is reachable' do
    feed = FactoryGirl.build(:feed, feed_url: 'http://my.broken.feed/feed/')
    expect(feed.valid?).to be false
    expect(feed.errors.messages).to include({:feed_url=>["Feed URL unreachable or error!"]})
  end


  context "as a User" do

    before :each do
      @user = FactoryGirl.create(:user)
      @feed = FactoryGirl.create(:feed, feed_url: 'http://need.computer/posts.atom')
    end

    it 'has unread items' do
      unread_items = @feed.unread_items(@user.id)
      expect(unread_items.count).to be > 1
      expect(unread_items.first).to be_an_instance_of(FeedItem)
    end

  end

end
