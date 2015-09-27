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

  def create
    feed = Feed.find_or_create_by(feed_params)
    if current_user.subscribe(feed)
      redirect_to feeds_path, notice: 'Feed added!'
    else
      redirect_to feeds_path, alert: "Could not subscribe to Feed! Wrong URL?"
    end
  end

  def destroy
    feed = current_user.feeds.find(params[:id])

    if current_user.unsubscribe(feed)
      redirect_to feeds_path
    end
  end

  private

    def feed_params
      params.require(:feed).permit(:feed_url)
    end
end
