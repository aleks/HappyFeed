class FeedsController < ApplicationController
  before_action :ensure_logged_in!

  def index
    @feeds = current_user.feeds.order('title').page(params[:page])
  end

  def show
    @feed = current_user.feeds.find(params[:id])
    @feed_items = @feed.feed_items.page(params[:page])
  end

  def new
    @feed = Feed.new
    render layout: false
  end

  def create
    feed = Feed.find_or_create_by(feed_url: feed_params[:feed_url])

    if current_user.subscribe(feed, feed_params[:group_id])
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    feed = current_user.feeds.find(params[:id])

    if current_user.unsubscribe(feed)
      redirect_to root_path, turbolinks: true
    end
  end

  def discover
    feed_url = feed_params[:feed_url]

    if Feedbag.feed?(feed_url)
      @feed_urls = [feed_url]
    else
      @feed_urls = []
      feed_urls = Feedbag.find(feed_url)
      feed_urls.each do |feed_url|
        @feed_urls << feed_url if Feedbag.feed?(feed_url)
      end
    end

    respond_to do |format|
      format.json
    end
  end

  def update_feed_group
    feed = current_user.feeds.find(feed_group_params[:feed_id])
    group = current_user.groups.find(feed_group_params[:group_id])

    if feed && group
      if current_user.unsubscribe(feed)
        current_user.subscribe(Feed.find(feed_group_params[:feed_id].to_i), group.id)
      end
    end
  end

  private

    def feed_params
      params.require(:feed).permit(:feed_url, :group_id)
    end

    def feed_group_params
      params.require(:feed).permit(:feed_id, :group_id)
    end
end
