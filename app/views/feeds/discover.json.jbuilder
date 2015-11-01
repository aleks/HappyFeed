if current_user && @feed_urls.size >= 1
  json.feed_urls @feed_urls
else
  json.error "No Feeds Found!"
end
