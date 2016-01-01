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
