class RoomsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "rooms_channel"
  end

  def receive(data)
    @types = {
      msg: "TEXT_MESSAGE",
      command: "TEXT_COMMAND",
      piece_move: "MOVE_VALIDATION"
    }

    case data["message_type"]

    when @types[:msg]
      then handle_text(data)
    when @types[:command]
      then handle_command(data)
    when @types[:piece_move]
      then handle_piece_move(data)
    else
      ActionCable.server.broadcast "rooms_channel", "Unknown message type"
    end

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private


  def handle_text(data)
    response = {
      message_type: "TEXT_MESSAGE_RECEIVED",
      data: data["text"]
    }

    ActionCable.server.broadcast 'rooms_channel', response
  end

  def handle_command(data)
    puts data["message_type"]
  end

  def handle_piece_move(data)
    response = {
      message_type: "MOVE_VALIDATION_RECEIVED",
      move: {
        start: data["details"]["starting_position"].split(':'),
        end: data["details"]["ending_position"].split(':'),
        isValid: true
      }
    }

    ActionCable.server.broadcast 'rooms_channel', response
  end

end
