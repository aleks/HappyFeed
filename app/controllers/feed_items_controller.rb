class FeedItemsController < ApplicationController
  before_action :ensure_logged_in!
  before_action :set_feed_item, only: [:show, :mark_read, :mark_unread, :mark_saved, :mark_unsaved]

  def show
    @feed_item.mark_as('read', current_user.id)
    @next_item = @feed_item.next_item
    @previous_item = @feed_item.previous_item
  end

  def mark_read
    @feed_item.mark_as('read', current_user.id)

    respond_to do |format|
      format.js
    end
  end

  def mark_unread
    @feed_item.mark_as('unread', current_user.id)

    respond_to do |format|
      format.js
    end
  end

  def mark_saved
    @feed_item.mark_as('saved', current_user.id)

    respond_to do |format|
      format.js
    end
  end

  def mark_unsaved
    @feed_item.mark_as('unsaved', current_user.id)

    respond_to do |format|
      format.js
    end
  end

  private

    def set_feed_item
      @feed_item = current_user.feeds.find(params[:feed_id]).feed_items.find(params[:id])
    end

end
