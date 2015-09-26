require 'rails_helper'

feature 'FeedItems Mangement' do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @feed = FactoryGirl.create(:feed, feed_url: 'http://heise.de.feedsportal.com/c/35207/f/653902/index.rss')
    FeedFetcher.new(@feed.id).fetch

    visit login_path
    fill_in 'login_email', with: 'user@happyfeed.tld'
    fill_in 'login_password', with: 'password'
    click_button 'Login'
  end

  # scenario 'Read a FeedItem' do
  #   visit feed_item_path(@feed.id, @feed.feed_items.first.id)
  #
  #   expect(page).to have_css('.feed_item .subline')
  #   expect(page).to have_css('.feed_item h1')
  #
  #   if @feed.feed_items.count > 1
  #     expect(page).to have_content('Next')
  #   end
  # end

end
