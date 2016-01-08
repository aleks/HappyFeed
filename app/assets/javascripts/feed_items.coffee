ready = ->

  if $('.feed_content').length == 1
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


    # Scroll Content via j/k and arrow up/down
    class FeedItemScrolling
      scrollable: ->
        curr_class_name = 'current_paragraph'

        item_index = 0
        $('.feed_content').children().each ->
          $(this).addClass(curr_class_name) if item_index == 0
          item_index += 1

        $('body').keypress (e) ->
          if e.key == 'j' or e.key == 'k'
            e.preventDefault()
            current_item = $('.' + curr_class_name)
            next_item = $(current_item).next() if e.key == 'j'
            next_item = $(current_item).prev() if e.key == 'k'

            if next_item.length == 1
              scroll_top_position = $('.scroll_content').scrollTop() + $(next_item).position().top -= 155
              $('.scroll_content').scrollTop(scroll_top_position)
              $(current_item).removeClass(curr_class_name)
              $(next_item).addClass(curr_class_name)

    feed_item_scrolling = new FeedItemScrolling
    feed_item_scrolling.scrollable()


    # Next / Previous Page via j/k keys
    class FeedItemPagination
      paginate: ->
        $('body').keypress (e) ->
          if e.key == 'h' or e.key == 'ArrowLeft'
            e.preventDefault()
            if previous_page_href = $('.previous-page').attr('href')
              window.location.href = previous_page_href
          if e.key == 'l' or e.key == 'ArrowRight'
            e.preventDefault()
            if next_page_href = $('.next-page').attr('href')
              window.location.href = next_page_href

    feed_item_pagination = new FeedItemPagination
    feed_item_pagination.paginate()

$(document).ready(ready)
$(document).on('page:load', ready)
