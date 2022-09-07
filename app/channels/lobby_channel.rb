class LobbyChannel < ApplicationCable::Channel
  @@players_count = 0

  def subscribed
    count = @@players_count
    @@players_count += 1
    stream_from "lobby_channel_global" do
      puts 'connected'
      sen1d('gggg')
    end
  end

  def unsubscribed
    @@players_count -= 1
    ActionCable.server.broadcast 'lobby_channel_global', {count: @@players_count}
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    puts data
    ActionCable.server.broadcast 'lobby_channel_global', data
  end

  private

  def sen1d(c)
    ActionCable.server.broadcast 'lobby_channel_global', {count: c}
  end
end
