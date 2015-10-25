ready = ->
  console.log 'yolo'

  $('#new_feed').on 'click', '.feed-urls .feed-url', ->
    update_feed_url $(this).data 'feed-url'

  $('#new_feed #feed_feed_url').on 'keyup', ->
    $('.feed-loading').show();
    $.ajax '/feeds/discover',
      type: "POST",
      data: { feed: { feed_url: $('#feed_feed_url').val() } },
      success: (data) ->
        if data['feed_urls'] != null
          add_feed_urls_to_form(data)
          $('.feed-loading').hide();
      fail: (data) ->
        console.log 'fail'

  add_feed_urls_to_form = (data) ->
    if data['feed_urls'].length == 0
      # display_error()
    else if data['feed_urls'].length == 1
      update_feed_url(data['feed_urls'][0])
    else
      add_options(data['feed_urls'])

  add_options = (feed_urls) ->
    $('.feed-urls').empty().show()
    for feed_url in feed_urls
      $('.feed-urls').append '<div class="feed-url" data-feed-url="' + feed_url + '">
        <span class="btn">Subscribe to this Feed</span>' + feed_url + '</div>'

  hide_options = ->
    $('.feed-urls').hide()

  update_feed_url = (feed_url) ->
    $('#feed_feed_url').val feed_url
    hide_options()

  display_error = ->
    $('.feed-urls').empty().show()
    $('.feed-urls').text "No Feed found for this URL. :("


$(document).ready(ready)
$(document).on('page:load', ready)
