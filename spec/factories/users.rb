FactoryGirl.define do
  factory :user do
    email 'user@happyfeed.tld'
    password 'password'
    password_confirmation 'password'
    auth_token Digest::MD5.hexdigest('user@happyfeed.tld' + ':' + 'password')
  end
end
