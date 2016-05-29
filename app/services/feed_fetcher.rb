class FeedFetcher
  include ActionView::Helpers::SanitizeHelper

  def initialize(id)
    @feed = Feed.find(id)
  end

  def fetch
    begin
      @fetched = Feedjira::Feed.fetch_and_parse(@feed.feed_url)
      unless @fetched == 304 || @fetched == 200 || @fetched == 404
        update_feed_info!
        store_feed_items
      end
    rescue Exception => e
      fetch_log = Logger.new('log/feed_fetcher.log')
      fetch_log.error "Feed: ID:#{@feed.id} Message: #{e.message}"
    end
  end

  def self.fetch_all
    Feed.all.each {|feed| FeedFetcherJob.perform_later(feed.id) }
  end

  def self.cleanup_item_content(feed_item_id)
    feed_item = FeedItem.find(feed_item_id)
    if feed_item.html.present?
      filters = [
        HappyFeed::SlodownFilter::Filter,
        HappyFeed::ImageProxyFilter::Filter
      ]
      filter = HTML::Pipeline.new(filters)
      html = filter.call(feed_item.html)
      new_html = html[:output].to_s.html_safe

      feed_item.update_attributes(html: new_html, cleaned: true)
    end
  end

  private

    def update_feed_info!
      @feed.title    = @fetched.title || @fetched.url
      @feed.site_url = @fetched.url
      @feed.last_updated_on_time = DateTime.now
      @feed.save
    end

    def store_feed_items
      if @fetched.entries
        # since we can't ensure that feed entries are created in their right
        # order we need to sort them by their respective publication date.
        entries = @fetched.entries.sort! {|a,b|
          if a.published.present? && b.published.present?
            DateTime.parse(a.published.to_s) <=> DateTime.parse(b.published.to_s)
          end
        }

        entries.each do |entry|
          create_feed_item(entry)
        end
      end
    end

    def create_feed_item(entry)
      item = @feed.feed_items.find_or_create_by(
        title: entry.title,
        url: entry.url,
      )

      unless item.cleaned
        item.author = entry.author
        item.html = fetched_content(entry)
        item.created_on_time = (entry.published ? entry.published.to_datetime : DateTime.now)
        item.save

        FeedItemJob.perform_later(item.id) # Fetch images later
      end
    end

    def fetched_content(entry)
      if summary_equals_content?(entry)
        entry.content
      else
        return entry.summary << entry.content if entry.summary && entry.content
        return entry.summary if entry.summary && entry.content.nil?
        return entry.content if entry.summary.nil? && entry.content
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
