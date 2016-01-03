ready = ->

  # Async Loading for Images
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


  # Resize iFrames
  $('.full_content iframe').each ->
    iframe_width = $(this).width()
    iframe_height = Math.round((iframe_width/16)*9);
    $(this).height(iframe_height)


  # Next / Previous Page via j/k keys
  $('body').keypress (e) ->
    if e.key == 'h' or e.key == 'ArrowLeft'
      e.preventDefault()
      if previous_page_href = $('.previous-page').attr('href')
        window.location.href = previous_page_href
    if e.key == 'l' or e.key == 'ArrowRight'
      e.preventDefault()
      if next_page_href = $('.next-page').attr('href')
        window.location.href = next_page_href

$(document).ready(ready)
$(document).on('page:load', ready)
