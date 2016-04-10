class ProxyController < ApplicationController

  # This should be replaced with real HTTP caching via NGINX or Varnish!
  # Just work in progress code.
  def image_proxy
    image_hash = params[:image_hash]
    image_body_hash = 'body_' + image_hash
    image_content_type_hash = 'content_type_' + image_hash

    url = URI.parse(Base64.strict_decode64(image_hash))

    unless Rails.cache.exist?(image_body_hash)
      image = HTTParty.get(url, verify: false, headers: {'User-Agent' => HF_USER_AGENT})
      image_body = Rails.cache.write(image_body_hash, image.body)
      image_content_type = Rails.cache.write(image_content_type_hash, image.content_type)
    else
      image_body = Rails.cache.fetch(image_body_hash)
      image_content_type = Rails.cache.fetch(image_content_type_hash)
    end

    send_data image_body, type: image_content_type, disposition: 'inline'

    # If you're working with a reverse proxy, use this part and comment the above!
    #
    # url = URI.parse(Base64.strict_decode64(params[:image_hash]))
    # image = HTTParty.get(url, verify: false, headers: {"User-Agent": HF_USER_AGENT})
    # send_data image.body, type: image.content_type, disposition: 'inline'
  end

end
