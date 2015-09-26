class FeedsController < ApplicationController
  before_action :ensure_logged_in!

  def index
    @feeds = current_user.feeds.order(:title)
    @feed = Feed.new
  end

  def show
    @feed = current_user.feeds.find(params[:id])
    @feed_items = @feed.feed_items.page(params[:page])
  end

  def edit
  end

  def update
    if @feed.update_attributes(feed_params)
      redirect_to feeds_path, notice: 'Feed saved!'
    end
  end

  def create
    feed = Feed.find_or_create_by(feed_params)
    user_feed = current_user.user_feeds.create(feed_id: feed.id)

    if user_feed.save
      GroupFeed.create(group_id: current_user.groups.find_by(default: true).id, feed_id: feed.id)
      FeedFetcher.new(feed.id).fetch
      redirect_to feeds_path, notice: 'Feed added!'
    else
      redirect_to feeds_path, alert: "Could not subscribe to Feed! Wrong URL?"
    end
  end

  def destroy
    @feed = current_user.feeds.find(params[:id])
    if @feed.destroy
      redirect_to feeds_path
    end
  end

  private

    def feed_params
      params.require(:feed).permit(:feed_url)
    end
end
