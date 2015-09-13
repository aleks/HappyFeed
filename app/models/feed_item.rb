class FeedItem < ActiveRecord::Base
  belongs_to :feed

  validates :feed_id, :title, :url, presence: true

  scope :unread, -> { where(is_read: nil) }
  scope :read, -> { where(is_read: true) }

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


  def next_item
    FeedItem.where('id > ? AND feed_id = ?', self.id, self.feed_id).limit(1).first
  end

  def previous_item
    FeedItem.where('id < ? AND feed_id = ?', self.id, self.feed_id).last
  end
end
