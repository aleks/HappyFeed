Gem.patching('feedjira', '2.0.0') do

  # Monkey Patch to add a User-Agent String to Feedjira Requests.
  # More: https://github.com/feedjira/feedjira/blob/faae46e3cdc59ab136c276166b2ed8164f27e987/lib/feedjira/feed.rb#L79-L84
  module Feedjira
    class Feed
      def self.connection(url)
        Faraday.new(url: url, headers: {'User-Agent': HF_USER_AGENT}) do |conn|
          conn.use FaradayMiddleware::FollowRedirects, limit: 3
          conn.adapter :net_http
        end
      end
    end
  end

  # We need to patch this method to prevent a few problems
  # with Feeds getting recognized as ITunesRSS when they are
  # not iTunes Feeds. In general this patch switches the Parser
  # order.
  # Original Source:
  # https://github.com/feedjira/feedjira/blob/master/lib/feedjira/feed.rb#L26-L31
  module Feedjira
    Feed.class_eval do
      def self.feed_classes
        @feed_classes = [
          Feedjira::Parser::RSS,
          Feedjira::Parser::Atom,
          Feedjira::Parser::RSSFeedBurner,
          Feedjira::Parser::AtomFeedBurner,
          Feedjira::Parser::GoogleDocsAtom,
          Feedjira::Parser::ITunesRSS
        ]
      end
    end
  end

end
