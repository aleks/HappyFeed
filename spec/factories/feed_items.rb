FactoryGirl.define do
  factory :feed_item do
    feed_id 1
    title "Feed Item Title"
    author "Feed Item Author"
    html "<strong>Lorem</strong> Ipsum"
    url "http://happyfeed.tld/lorem-ipsum"
    is_saved false
    is_read false
    created_on_time DateTime.now
    published_at DateTime.now
  end

end
