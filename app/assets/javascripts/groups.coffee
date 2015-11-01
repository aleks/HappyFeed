class Group
  update_feed_group: (data) ->
    $.ajax '/feeds/update_feed_group',
      type: "POST",
      dataType: 'json',
      data: { feed: { feed_id: data['feed_id'], group_id: data['group_id'] } }

@group = new Group
