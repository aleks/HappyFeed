class FeedItem < ActiveRecord::Base
  belongs_to :feed

  validates :feed_id, :title, :url, presence: true

  def mark_as(mark)
    case mark
      when 'read'
        update_attribute(:is_read, true)
      when 'unread'
        update_attribute(:is_read, nil)
      when 'saved'
        update_attribute(:is_saved, true)
      when 'unsaved'
        update_attribute(:is_saved, nil)
    end
  end
end
