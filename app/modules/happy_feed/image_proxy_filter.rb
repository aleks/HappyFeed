module HappyFeed
  module ImageProxyFilter

    class Filter < HTML::Pipeline::Filter
      def call
        doc.search("img").each do |img|
          begin
            next if img['src'].nil?

            remote_image = Dragonfly.app.fetch_url(img['src'].strip)
            local_image = remote_image.store

            # Remove width and height
            img['width'] = nil
            img['height'] = nil

            # Assign real src as data attribute
            http = Rails.env.development? ? 'http://' : 'https://'
            img['src'] = [
              http, ENV['SITE_URL'],
              Dragonfly.app.remote_url_for(local_image)
            ].join

            wrap_image(img)
          rescue Errno::ECONNREFUSED
            next
          end
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
