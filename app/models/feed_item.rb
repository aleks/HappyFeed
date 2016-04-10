class FeedItem < ActiveRecord::Base
  include FeedItemHelper

  belongs_to :feed
  has_many :feed_item_reads
  has_many :feed_item_stars

  validates :feed_id, :title, :url, presence: true

  after_commit :enqueue_preload_images, on: :create

  def mark_as(mark, user_id)
    case mark
      when 'read'
        unless feed_item_reads.find_by(feed_item_id: id, user_id: user_id)
          feed_item_reads.create(feed_id: feed_id, user_id: user_id)
        end
      when 'unread'
        feed_item_reads.find_by(feed_item_id: id, user_id: user_id).try(:destroy)
      when 'saved'
        unless feed_item_stars.find_by(feed_item_id: id, user_id: user_id)
          feed_item_stars.create(feed_id: feed_id, user_id: user_id)
        end
      when 'unsaved'
        feed_item_stars.find_by(feed_item_id: id, user_id: user_id).try(:destroy)
    end
  end

  def next_item
    FeedItem.where('id > ? AND feed_id = ?', self.id, self.feed_id).limit(1).first
  end

  def previous_item
    FeedItem.where('id < ? AND feed_id = ?', self.id, self.feed_id).last
  end

  def word_count
    html.split(' ').count
  end

  def length_in_time(wpm = 130)
    word_count.to_f / wpm.to_f
  end

  def enqueue_preload_images
    FeedItemJob.perform_later(id)
  end

  def preload_images
    rendered_html = build_feed_item_content(html, true)
    image_urls = URI.extract(rendered_html).find_all {|url| url =~ /image\_proxy/}
    if image_urls.any?
      image_urls.each do |image_url|
        begin
          HTTParty.get(image_url, verify: false, headers: {'User-Agent' => HF_USER_AGENT})
        rescue HTTParty::Error
          # fail
        end
      end
    end
  end
end
