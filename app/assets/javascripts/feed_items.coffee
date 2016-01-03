ready = ->
  class ImageLoader

    load_item_image: (img) ->
      target_image = img
      image_url = $(target_image).data('image-proxy-src')

      if image_url
        $.ajax image_url,
          cache: true,
          processData: false
          complete: ->
            $(target_image).attr('src', image_url)
            $(target_image).removeClass('loading_image')

  $('.full_content img').each ->
    image_loader = new ImageLoader
    image_loader.load_item_image(this)

  $('.full_content iframe').each ->
    iframe_width = $(this).width()
    iframe_height = Math.round((iframe_width/16)*9);
    $(this).height(iframe_height)

$(document).ready(ready)
$(document).on('page:load', ready)
