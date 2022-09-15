class LobbyChannel < ApplicationCable::Channel
  require 'chess_in_mem_cache'

  after_unsubscribe :send_unsubed_user

  @@cache = ChessInMemCache.instance

  @@message_types = {
    chat: "GLOBAL_CHAT_MESSAGE",
    user_sub: "USER_SUBSCRIBED",
    user_unsub: "USER_UNSUBSCRIBED",
    create_room: "ROOM_CREATED",
    delete_room: "ROOM_DELETED",
  }

  def subscribed
    stream_from "lobby_channel_global"
    user = "#{current_user[:id]}:#{current_user[:user]}"
    @@cache.add(user)
    send_subed_user(user)
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

  def send_subed_user(user)
    ActionCable.server.broadcast 'lobby_channel_global', {type: @@message_types[:user_sub], user: user}
  end

  def send_unsubed_user
    ActionCable.server.broadcast 'lobby_channel_global', {type: @@message_types[:user_unsub], user: current_user[:user]}
  end

  def broadcast_chat_message(data)
    ActionCable.server.broadcast 'lobby_channel_global', {
      type: @@message_types[:chat],
      data: {
        user: data["user"],
        message: data["message"],
        color: data["color"]
      }
    }
  end
end
