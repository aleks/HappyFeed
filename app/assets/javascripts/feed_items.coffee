ready = ->
  class ImageLoader

    load_item_image: (img) ->
      target_image = img
      image_url = $(target_image).data('image-proxy-src')

      $.ajax image_url,
        cache: true,
        processData: false
        complete: ->
          $(target_image).attr('src', image_url)
          $(target_image).removeClass('loading_image')

  $('.full_content img').each ->
    image_loader = new ImageLoader
    image_loader.load_item_image(this)

  # Keep Pre-Tags aligned with content width.
  $('pre').hide()
  $('pre').css('width', $('.full_content').css('width'))
  $('pre').show()

$(document).ready(ready)
$(document).on('page:load', ready)
