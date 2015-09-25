require 'json'

class FeverController < ApplicationController
  protect_from_forgery except: :fever

  before_action :auth

  def fever
    auth = { api_version: 2, auth: 1, last_refreshed_on_time: Time.now.to_i }
    results = get_api_endpoint(params)

    api_response = auth.merge!(results)

puts api_response

    render json: api_response.to_json
  end


  private

    def auth
      @api_user = User.find_by auth_token: params[:api_key]

      if @api_user
        true
      else
        render :nothing => true, :status => 403 # Todo: pruefen!
      end
    end

    def get_api_endpoint(params)
      if params.keys.include?('groups')
        groups
      elsif params.keys.include?('feeds')
        feeds
      elsif params.keys.include?('items')
        items
      elsif params.keys.include?('links')
        links
      elsif params.keys.include?('favicons')
        favicons
      elsif params.keys.include?('unread_item_ids')
        unread_item_ids
      elsif params.keys.include?('saved_item_ids')
        saved_item_ids
      elsif params.keys.include?('mark')
        mark(params)
      else
        {}
      end
    end

    def groups
      user_groups = []
      @api_user.groups.each do |g|
        user_groups << {id: g.id, title: g.title}
      end

      { groups: user_groups, feeds_groups: feeds_groups }
    end

    def feeds
      feeds = []
      @api_user.feeds.each do |f|
        feeds << {
          id: f.id,
          favicon_id: 1,
          title: f.title,
          url: f.feed_url,
          site_url: f.site_url,
          is_spark: 0 || f.is_spark,
          last_updated_on_time: f.updated_at.to_i
        }
      end

      { feeds: feeds, feeds_groups: feeds_groups }
    end

    def feeds_groups
      groups = []
      @api_user.groups.each do |g|
        groups << {group_id: g.id, feed_ids: g.feeds.map{|f| f.id}.join(",")}
      end

      groups
    end

    def favicons
      [{
        id: 1,
        data: "image/gif;base64,R0lGODlhAQABAIAAAObm5gAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="
      }]
    end

    def items
      if params[:since_id]
        feed_items = FeedItem.joins(:feed).where(feeds: {user_id: @api_user.id}).where('feed_items.id > ?', params[:since_id])
      elsif params[:with_ids]
        feed_items = FeedItem.joins(:feed).where(feeds: {user_id: @api_user.id}).where('feed_items.id IN (?)', params[:with_ids].split(','))
      else
        feed_items = FeedItem.joins(:feed).where(feeds: {user_id: @api_user.id})
      end

      items = []
      feed_items.each do |item|
        items << {
          id: item.id,
          feed_id: item.feed_id,
          title: item.title,
          author: item.author,
          html: item.html,
          url: item.url,
          is_saved: item.is_saved,
          is_read: item.is_read,
          created_on_time: item.created_on_time.to_i
        }
      end

      { items: items, total_items: items.count }
    end

    def links
      { items: [], total_items: 0 }
    end

    def unread_item_ids
      { unread_item_ids: @api_user.unread_item_ids.join(',') }
    end

    def saved_item_ids
      { saved_item_ids: @api_user.saved_item_ids.join(',') }
    end

    def mark(params)
      mark_feed(params)   if params[:mark] == "feed"
      mark_group(params)  if params[:mark] == "group"
      mark_item(params)   if params[:mark] == "item"

      {}
    end

    def mark_feed(params)
      if params[:as] == "read"
        FeedItem.joins(:feed).where(
          feeds: { id: params[:id], user_id: @api_user.id},
          feed_items: { is_read: nil }
        ).where('created_on_time <= ?', Time.at(params[:before].to_i))
        .update_all(is_read: true)
      end
    end

    def mark_group(params)
      if params[:as] == "read"
        FeedItem.joins(:feed).where(
          feeds: { group_id: params[:id], user_id: @api_user.id},
          feed_items: { is_read: nil }
        ).where('created_on_time <= ?', Time.at(params[:before].to_i))
        .update_all(is_read: true)
      end
    end

    def mark_item(params)
      FeedItem.find(params[:id]).mark_as(params[:as], @api_user.id)
    end

end
