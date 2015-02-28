FactoryGirl.define do
  factory :feed do
    user_id 1
    group_id 1
    title "News Site"
    feed_url "http://happyfeed.tld/feed"
    site_url "http://happyfeed.tld"
    is_spark false
    last_updated_on_time DateTime.now
  end

end
