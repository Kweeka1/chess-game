class ChessHelper

  def self.handle_message(received)
    puts received
    data = received["message"]

    case data["message_type"]
    when @types["msg"]
      then handle_text(data)
    when @types["command"]
      then handle_command(data)
    when @types["piece_move"]
      then handle_piece_move(data)
    else ActionCable.server.broadcast "rooms_channel", "Unknown message type"
    end

  end

  private

  @types = {
    msg: "TEXT_MESSAGE",
    command: "TEXT_COMMAND",
    piece_move: "MOVE_VALIDATION"
  }

  def handle_text(data)
    puts data
    response = {
      message_type: "TEXT_MESSAGE_RECEIVED",
      data: data
    }

    ActionCable.server.broadcast 'rooms_channel', response
  end

  def handle_command(data)
    puts data["message"]
  end

  def handle_piece_move(data)
    puts data["message"]
  end

end