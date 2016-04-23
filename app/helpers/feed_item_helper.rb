module FeedItemHelper
  def build_feed_item_content(feed_item_html, external = nil)
    if feed_item_html

      if external
        filters = [
          HappyFeed::SlodownFilter::Filter,
        ]
      else
        filters = [
          HappyFeed::SlodownFilter::Filter,
        ]
      end

      filter = HTML::Pipeline.new(filters)
      content = filter.call feed_item_html
      content[:output].to_s.html_safe
    end
  end
end
