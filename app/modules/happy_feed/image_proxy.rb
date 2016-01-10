module HappyFeed
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

          wrap_image(img)
        end

        doc
      end

      def wrap_image(image)
        image_wrap = doc.document.create_element('div', :class => 'image_wrap')
        image_wrap.add_child(image.dup)
        image.replace(image_wrap)
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
end
