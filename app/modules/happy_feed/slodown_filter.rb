module HappyFeed
  module SlodownFilter

    class Filter < HTML::Pipeline::TextFilter
      def call
        HappyFeedFormatter.new(@text).sanitize.to_s.html_safe
      end
    end

    class HappyFeedFormatter < Slodown::Formatter
      private

      def sanitize_config
        {
          elements: %w(
            p br a span sub sup strong em div hr abbr s
            ul ol li
            blockquote pre code kbd
            h1 h2 h3 h4 h5 h6
            img object param del
          ),
          attributes: {
            :all     => ['class', 'style', 'title', 'id'],
            'a'      => ['href', 'rel', 'name'],
            'li'     => ['id'],
            'sup'    => ['id'],
            'img'    => ['src', 'title', 'alt', 'width', 'height'],
            'object' => ['width', 'height'],
            'param'  => ['name', 'value'],
            'embed'  => ['allowscriptaccess', 'width', 'height', 'src'],
            'iframe' => ['src']
          },
          protocols: {
            'a' => { 'href' => ['ftp', 'http', 'https', 'mailto', '#fn', '#fnref', :relative] },
            'img' => {'src'  => ['http', 'https', :relative]},
            'iframe' => {'src'  => ['http', 'https']},
            'embed' => {'src'  => ['http', 'https']},
            'object' => {'src'  => ['http', 'https']},
            'li' => {'id' => ['fn']},
            'sup' => {'id' => ['fnref']}
          },
          transformers: EmbedTransformer
        }
      end
    end

    class EmbedTransformer
      ALLOWED_DOMAINS = %w[youtube.com soundcloud.com vimeo.com]

      def self.call(env)
        node      = env[:node]
        node_name = env[:node_name]

        return if env[:is_whitelisted] || !env[:node].element?
        return unless %w[iframe embed].include? env[:node_name]

        uri = URI(env[:node]['src'])
        domains = ALLOWED_DOMAINS.map { |d| Regexp.escape(d) }.join("|")
        return unless uri.host =~ /^(.+\.)?(#{domains})/

        Sanitize.clean_node!(node, {
          elements: %w[iframe embed],
          attributes: {
            all: %w[src]
          }
        })

        node['width'] = '100%'
        node['frameborder'] = '0'

        { node_whitelist: [node] }
      end
    end

  end
end
