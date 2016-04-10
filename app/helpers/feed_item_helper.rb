module FeedItemHelper
  def build_feed_item_content(feed_item_html, external = nil)
    if feed_item_html

      if Rails.env.production?
        context = { image_proxy_base_url: "https://#{ENV['SITE_URL']}/image_proxy/" }
      else
        context = { image_proxy_base_url: "http://localhost:3000/image_proxy/" }
      end

      if external
        filters = [
          HappyFeed::SlodownFilter::Filter,
          HappyFeed::ImageProxy::FilterExternal
        ]
      else
        filters = [
          HappyFeed::SlodownFilter::Filter,
          HappyFeed::ImageProxy::Filter
        ]
      end

      filter = HTML::Pipeline.new filters, context
      content = filter.call feed_item_html
      content[:output].to_s.html_safe
    end
  end
end
