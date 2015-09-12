class FeedsController < ApplicationController
  before_action :ensure_logged_in!
  before_action :set_feed, only: [:show, :edit, :update]

  def index
    @feeds = current_user.feeds.order(:title)
    @feed = Feed.new(group_id: current_user.groups.find_by(default: true).id)
  end

  def show
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
    @feed = current_user.feeds.new(feed_params)

    if @feed.save
      FeedFetcher.new(@feed.id).fetch
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

    def set_feed
      @feed = current_user.feeds.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:feed_url, :group_id)
    end
end
