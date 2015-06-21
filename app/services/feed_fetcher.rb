class FeedFetcher
  include ActionView::Helpers::SanitizeHelper

  USER_AGENT = 'HappyFeed'

  def initialize(id)
    @feed = Feed.find(id)
  end

  def fetch
    @fetched = Feedjira::Feed.fetch_and_parse(@feed.feed_url, user_agent: USER_AGENT, timeout: 30, max_redirects: 3)

    unless @fetched == 304 || @fetched == 200 || @fetched == 404
      update_feed_info!
      store_feed_items
    end
  end

  private

    def update_feed_info!
      @feed.title    = @fetched.title
      @feed.site_url = @fetched.url
      @feed.save
    end

    def store_feed_items
      if entries = @fetched.entries
        entries.each do |entry|
          create_feed_item(entry)
        end
      end
    end

    def create_feed_item(entry)
      @feed.feed_items.find_or_create_by(
        title: entry.title,
        author: entry.author,
        html: fetched_content(entry),
        url: entry.url,
        created_on_time: entry.published.to_datetime
      )
    end

    def fetched_content(entry)
      if summary_equals_content?(entry)
        entry.content.sanitize
      else
        return entry.summary.sanitize << entry.content.sanitize if entry.summary && entry.content
        return entry.summary.sanitize if entry.summary && entry.content.nil?
        return entry.content.sanitize if entry.summary.nil? && entry.content
      end
    end

    def summary_equals_content?(entry)
      if entry.summary && entry.content
        summary = strip_tags(entry.summary.gsub(/\n| /,''))[0..15]
        content = strip_tags(entry.content.gsub(/\n| /,''))[0..15]
        true if summary == content
      end
    end
end
