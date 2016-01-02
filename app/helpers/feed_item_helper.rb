module FeedItemHelper
  def build_feed_item_content(feed_item_html, api_key = nil)
    if feed_item_html
      context = {
        api_key: "/api_key/#{api_key}",
        image_proxy_base_url: 'http://localhost:3000/image_proxy/'
      }

      if api_key
        filters = [
          HappyFeed::Videos::RewriteIframe,
          HTML::Pipeline::SanitizationFilter,
          HappyFeed::Videos::SecureEmbed,
          HappyFeed::ImageProxy::FilterWithAPIKey
        ]
      else
        filters = [
          HappyFeed::Videos::RewriteIframe,
          HTML::Pipeline::SanitizationFilter,
          HappyFeed::Videos::SecureEmbed,
          HappyFeed::ImageProxy::Filter
        ]
      end

      filter = HTML::Pipeline.new filters, context
      content = filter.call feed_item_html
      content[:output].to_s.html_safe
    end
  end
end
