module FeedItemHelper
  def build_feed_item_content(feed_item_html, api_key = nil)
    context = {
      api_key: "/api_key/#{api_key}",
      image_proxy_base_url: 'http://localhost:3000/image_proxy/'
    }

    if api_key
      filters = [
        HTML::Pipeline::SanitizationFilter,
        ImageProxy::FilterWithAPIKey
      ]
    else
      filters = [
        HTML::Pipeline::SanitizationFilter,
        ImageProxy::Filter
      ]
    end

    filter = HTML::Pipeline.new filters, context
    content = filter.call feed_item_html
    content[:output].to_s.html_safe
  end
end

module ImageProxy
  class Filter < HTML::Pipeline::Filter
    def call
      doc.search("img").each do |img|
        next if img['src'].nil?

        base64_src = CGI::escape(Base64.strict_encode64(img['src'].strip))

        # Remove width and height
        img['width'] = nil
        img['height'] = nil

        # Add loading.gif as pre-image
        img['class'] = 'loading_image'
        img['src'] = ActionController::Base.helpers.asset_path('loading.gif')

        # Assign real src as data attribute
        img['data-image-proxy-src'] = [context[:image_proxy_base_url], base64_src].join
      end

      doc
    end
  end

  class FilterWithAPIKey < HTML::Pipeline::Filter
    def call
      doc.search("img").each do |img|
        next if img['src'].nil?

        base64_src = CGI::escape(Base64.strict_encode64(img['src'].strip))

        # Remove width and height
        img['width'] = nil
        img['height'] = nil

        # Assign real src as data attribute
        img['src'] = [context[:image_proxy_base_url], base64_src, context[:api_key]].join
      end

      doc
    end
  end
end
