class UserChannel < ApplicationCable::Channel
  require 'chess_in_mem_cache'

  @@cache = ChessInMemCache.instance

  @@message_types = {
    current_rooms: "ACTIVE_ROOMS",
    current_users: "ONLINE_USERS",
    join_request: "JOIN_REQUEST",
    view_request: "VIEW_REQUEST"
  }

  def subscribed
    stream_from "user_channel_#{params[:user]}"
    send_subed_users
    send_active_rooms
  end

  def receive(request)
    case request["type"]
      when @@message_types[:join_request]
        then handle_join_request(request["data"]["guest"], request["data"]["host"], request["data"]["room"])
      when @@message_types[:view_request]
        then handle_view_request(request["data"]["guest"], request["data"]["host"], request["data"]["room"])
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_subed_users
    cache = @@cache.all
    users = cache.is_a?(Array) ? cache : cache.to_a
    ActionCable.server.broadcast "user_channel_#{params[:user]}", {type: @@message_types[:current_users], data: users}
  end

  def send_active_rooms
    rooms = Room.all
    ActionCable.server.broadcast "user_channel_#{params[:user]}", {type: @@message_types[:current_rooms], data: rooms}
  end

  def handle_join_request(guest, host, room)
    ActionCable.server.broadcast "user_channel_#{host}", { type: @@message_types[:join_request], data: { guest: guest, room: room }}
  end

  def handle_view_request(guest, host, room)
    ActionCable.server.broadcast "user_channel_#{host}", { type: @@message_types[:view_request], data: { guest: guest, room: room }}
  end
end
