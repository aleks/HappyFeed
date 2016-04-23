class Feed
  form_handler: ->
    if $('#new_feed').length >= 1
      if $('#new_feed #feed_feed_url').val().length == 0
        $('.to-screen-2').prop('disabled', true)

      $('#new_feed button.to-screen-2').on 'click', (e) ->
        e.preventDefault()
        $('.screen-1').hide()
        $('.screen-2').show()

      $('#new_feed').on 'click', '.feed-urls .feed-url', ->
        update_feed_url $(this).data 'feed-url'

      $('#new_feed #feed_feed_url').bindWithDelay 'keyup', ->
        if $('#new_feed #feed_feed_url').val().length >= 1
          $.ajax '/feeds/discover',
            type: "POST",
            dataType: 'json',
            data: { feed: { feed_url: $('#feed_feed_url').val() } },
            beforeSend: ->
              hide_options()
              $('.feed-loading').show()
            success: (data) ->
              hide_loading()
              handle_response(data)
            fail: (data) ->
              console.log "Connection Error: Couldn't request feed!"
        else
          $('.to-screen-2').prop('disabled', true)
      , 500

      handle_response = (data) ->
        if data['error']
          display_error(data)
          hide_loading()
          $('.to-screen-2').prop('disabled', false)
        else if data['feed_urls'].length == 1
          update_feed_url(data['feed_urls'][0])
          $('.to-screen-2').prop('disabled', false)
        else
          add_options(data['feed_urls'])

      add_options = (feed_urls) ->
        $('.feed-urls').empty().show()
        for feed_url in feed_urls
          $('.feed-urls').append '<div class="feed-url" data-feed-url="' + feed_url + '">
            <span class="btn">Subscribe to this Feed</span>' + feed_url + '</div>'

      hide_options = ->
        $('.feed-urls').hide()

      hide_loading = ->
        $('.feed-loading').hide()

      update_feed_url = (feed_url) ->
        $('#feed_feed_url').val feed_url
        hide_options()
        $('.to-screen-2').prop('disabled', false)

      display_error = (data) ->
        hide_loading()
        $('.feed-urls').empty().show()
        $('.feed-urls').text(data['error'])

@feed = new Feed
