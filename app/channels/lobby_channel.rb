class LobbyChannel < ApplicationCable::Channel
  require 'chess_in_mem_cache'

  after_subscribe :send_subed_users
  after_unsubscribe :send_unsubed_user
  @@players_count = []

  @@cache = ChessInMemCache.instance

  @@message_types = {
    chat: "GLOBAL_CHAT_MESSAGE",
    user_sub: "USER_SUBSCRIBED",
    user_unsub: "USER_UNSUBSCRIBED",
    create_room: "ROOM_CREATE",
    delete_room: "ROOM_DELETE",
  }

  def subscribed
    stream_from "lobby_channel_global"
    @@cache.add("#{current_user[:id]}:#{current_user[:user]}")
  end
  def unsubscribed
    @@cache.remove("#{current_user[:id]}:#{current_user[:user]}")
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    case data["message_type"]
      when @@message_types[:chat]
        then broadcast_chat_message(data["data"])
    end
    #ActionCable.server.broadcast 'lobby_channel_global', {type: @@message_types[:user_sub], users: @@players_count}
  end

  private

  def send_subed_users
    users = @@cache.all
    ActionCable.server.broadcast 'lobby_channel_global', {type: @@message_types[:user_sub], users: users}
  end

  def send_unsubed_user
    ActionCable.server.broadcast 'lobby_channel_global', {type: @@message_types[:user_unsub], user: current_user[:user]}
  end

  def broadcast_chat_message(data)
    ActionCable.server.broadcast 'lobby_channel_global', {
      type: @@message_types[:chat],
      data: {
        user: data["user"],
        message: data["message"]
      }
    }
  end
end
