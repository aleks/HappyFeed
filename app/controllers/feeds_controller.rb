class FeedsController < ApplicationController
  before_action :ensure_logged_in!

  def index
    @feeds = current_user.feeds.order(:title)
    @feed = Feed.new(group_id: current_user.groups.find_by(default: true).id)
  end

  def edit
    @feed = current_user.feeds.find(params[:id])
  end

  def update
    @feed = current_user.feeds.find(params[:id])
    if @feed.update_attributes(feed_params)
      redirect_to feeds_path, notice: 'Feed saved!'
    end
  end

  def create
    @feed = current_user.feeds.new(feed_params)
    if @feed.save
      redirect_to feeds_path, notice: 'Feed added!'
      FeedFetcher.new(@feed.id).fetch
    else
      redirect_to feeds_path, alert: 'Error while saving! Already subscribed?'
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
      params.require(:feed).permit(:feed_url, :group_id)
    end
end
