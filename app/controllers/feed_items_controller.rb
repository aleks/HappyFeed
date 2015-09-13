class FeedItemsController < ApplicationController
  before_action :ensure_logged_in!
  before_action :set_feed_item, only: [:show]

  def show
    @next_item = @feed_item.next_item
    @previous_item = @feed_item.previous_item
  end

  private

    def set_feed_item
      @feed_item = current_user.feeds.find(params[:feed_id]).feed_items.find(params[:id])
    end

end
