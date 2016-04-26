ready = ->

  if $('.feed_content').length == 1

    # Resize iFrames
    $('.full_content iframe').each ->
      iframe_width = $(this).width()
      iframe_height = Math.round((iframe_width/16)*9)
      $(this).height(iframe_height)


    # Keyboard Shortcuts
    class FeedItemScrolling
      load: ->
        curr_class_name = 'current_paragraph'

        first_item = $('.feed_content').children().first()
        first_item.addClass(curr_class_name)

        unless $('.modal').is(':visible')
          Mousetrap.bind ['j', 'k'], (e) ->
            current_item = $('.' + curr_class_name)
            next_item = $(current_item).next() if e.code == 'KeyJ'
            next_item = $(current_item).prev() if e.code == 'KeyK'

            if next_item.length == 1
              scroll_top_position = $('.scroll_content').scrollTop() + $(next_item).position().top -= 155
              $('.scroll_content').scrollTop(scroll_top_position)
              $(current_item).removeClass(curr_class_name)
              $(next_item).addClass(curr_class_name)


    class FeedItemPagination
      load: ->
        unless $('.modal').is(':visible')
          Mousetrap.bind ['h', 'left', 'l', 'right'], (e) ->
            if e.code == 'KeyH' or e.code == 'ArrowLeft'
              if previous_page_href = $('.previous-page').attr('href')
                Turbolinks.visit(previous_page_href)
            if e.code == 'KeyL' or e.code == 'ArrowRight'
              if next_page_href = $('.next-page').attr('href')
                Turbolinks.visit(next_page_href)

    class FeedItemSaving
      load: ->
        unless $('.modal').is(':visible')
          Mousetrap.bind ['s'], (e) ->
            $('.toggle_save_unsave').click()

    class FeedItemUnread
      load: ->
        unless $('.modal').is(':visible')
          Mousetrap.bind ['u'], (e) ->
            $('.mark_unread').click()

    class FeedItemUrlOpen
      load: ->
        unless $('.modal').is(':visible')
          Mousetrap.bind ['o'], (e) ->
            url = $('a.url_open').attr('href')
            window.open(url)

    feed_item_scrolling = new FeedItemScrolling
    feed_item_scrolling.load()

    feed_item_pagination = new FeedItemPagination
    feed_item_pagination.load()

    feed_item_saving = new FeedItemSaving
    feed_item_saving.load()

    feed_item_unread = new FeedItemUnread
    feed_item_unread.load()

    feed_item_url_open = new FeedItemUrlOpen
    feed_item_url_open.load()

$(document).ready(ready)
$(document).on('page:load', ready)
