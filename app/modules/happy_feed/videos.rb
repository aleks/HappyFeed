module HappyFeed
  module Videos

    class RewriteIframe < HTML::Pipeline::Filter
      def call
        doc.search("iframe").each do |iframe|
          case iframe['src']
            when /youtube/
              Video.new.transform_iframe_to_text(iframe, 'youtube')
            when /vimeo/
              Video.new.transform_iframe_to_text(iframe, 'vimeo')
          end
        end

        doc
      end
    end

    class SecureEmbed < HTML::Pipeline::Filter
      def call
        doc.search('.//text()').each do |node|
          if video_node = node.to_html.match(/\[(.*)\s(.*)\s(.*)\]/)
            if video_node[2] =~ /youtube|vimeo/
              new_html = Video.new.secure_embed(video_node[3], video_node[2])
              node.replace(new_html)
            end
          end
        end

        doc
      end
    end

    class Video
      def transform_iframe_to_text(iframe, provider)
        puts iframe
        new_node = iframe.document.create_element ""
        new_node.inner_html = "[videolink #{provider} #{iframe['src']}]"
        iframe.replace new_node
      end

      def secure_embed(src, provider)
        puts src
        if ALLOW_VIDEO_EMBEDS == true
          <<-VIDEOEMBED
          <div class='secure-video-wrap'>
            <iframe width="100%" height="400" src='#{src}' class='#{provider}-video-embed'>#{src}</iframe>
          </div>
          VIDEOEMBED
        else
          <<-VIDEOTEXTLINK
          <div class='secure-video-wrap'>
            <a href='#{src}' class='#{provider}-link' target='_blank'>Embedded Video removed - Open Video</a>
          </div>
          VIDEOTEXTLINK
        end
      end
    end

  end
end
