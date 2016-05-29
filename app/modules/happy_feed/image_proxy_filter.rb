module HappyFeed
  module ImageProxyFilter

    class Filter < HTML::Pipeline::Filter
      def call
        doc.search("img").each do |img|
          next if img['src'].nil?

          http = Rails.env.development? ? 'http://' : 'https://'

          begin
            # Fetch remote image
            remote_image = Dragonfly.app.fetch_url(img['src'].strip)
            if remote_image.image?

              # Store orignal and thumbnail
              local_image = remote_image.store
              thumb_image = remote_image.thumb('50x50').store

              img['width'] = remote_image.width
              img['height'] = remote_image.height

              # Add thumbnail src
              img['data-original'] = [
                http, ENV['SITE_URL'],
                Dragonfly.app.remote_url_for(local_image)
              ].join

              # Add original src
              img['src'] = [
                http, ENV['SITE_URL'],
                Dragonfly.app.remote_url_for(thumb_image)
              ].join
            end
          rescue Exception
            img['src'] = [
              http, ENV['SITE_URL'], '/image_fetching_failed.png'
            ].join
          end
          wrap_image(img)
        end
        doc
      end

      def wrap_image(image)
        if image.parent.name == "a"
          image = image.parent
        end

        image_wrap = doc.document.create_element('span', :class => 'image_wrap')
        image_wrap.add_child(image.dup)
        image.replace(image_wrap)

        if image_wrap.parent.name != 'p'
          image_wrap_p = doc.document.create_element('p')
          image_wrap_p.add_child(image_wrap.dup)
          image_wrap.replace(image_wrap_p)
        end
      end
    end

  end
end
