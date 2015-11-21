FactoryGirl.define do
  factory :feed_item do
    feed_id 1
    title "Feed Item Title"
    author "Feed Item Author"
    html "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Aenean lacinia bibendum nulla sed consectetur. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    url "http://happyfeed.tld/lorem-ipsum"
    created_on_time DateTime.now
  end

end
