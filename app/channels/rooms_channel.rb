class RoomsChannel < ApplicationCable::Channel
  require 'chess'
  require 'chess_in_mem_cache'

  @@types = {
    msg: "TEXT_MESSAGE",
    command: "TEXT_COMMAND",
    piece_move: "MOVE_VALIDATION"
  }
  def subscribed
    cache = ChessInMemCache.instance
    @board = cache.get_chess_board(params[:room])
    stream_from "rooms_#{params[:room]}"
  end

  def receive(data)

    case data["message_type"]

    when @@types[:msg]
      then handle_text(data)
    when @@types[:command]
      then handle_command(data)
    when @@types[:piece_move]
      then handle_piece_move(data)
    else
      ActionCable.server.broadcast "rooms_channel", "Unknown message type"
    end

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    cache = ChessInMemCache.instance
    cache.store_chess_board(params[:room], @board)
  end

  private


  def handle_text(data)
    response = {
      message_type: "TEXT_MESSAGE_RECEIVED",
      data: data["text"]
    }

    ActionCable.server.broadcast "rooms_#{params[:room]}", response
  end

  def handle_command(data)
    puts data["message_type"]
  end

  def handle_piece_move(data)
    move = data["details"]

    result = validate_move(move["last_piece"],
                           move["starting_position"],
                           move["ending_position"],
                           move["occupier"],
                           move["turn"],
                           move["map"])

    response = {
      message_type: "MOVE_VALIDATION_RECEIVED",
      move: {
        start: data["details"]["starting_position"].split(':'),
        end: data["details"]["ending_position"].split(':'),
        isValid: result
      }
    }

    ActionCable.server.broadcast "rooms_#{params[:room]}", response
    end

  def validate_knight_move(piece_start, piece_end)
    row_move = (piece_start[0].to_i - piece_end[0].to_i).abs
    col_move = (piece_start[1].to_i - piece_end[1].to_i).abs
    puts 'knight validation'
    if row_move + col_move === 3
      temp = @board[piece_end[0].to_i][piece_end[1].to_i]
      @board[piece_end[0].to_i][piece_end[1].to_i] = @board[piece_start[0].to_i][piece_start[1].to_i]
      @board[piece_start[0].to_i][piece_start[1].to_i] = temp
      puts @board[piece_start[0].to_i][piece_start[1].to_i]

      true
    end
  end

  def bishop_move(map, start_col, end_col, index)
    if end_col > start_col
      @col += 1
      if map[(index * 8) + @col] != ""
        return true
      end
    else
      @col -= 1
      if map[(index * 8) + @col] != ""
        return true
      end
    end
    false
  end

  def validate_bishop_move(piece_start, piece_end, territories)
    row_move = (piece_start[0].to_i - piece_end[0].to_i).abs
    col_move = (piece_start[1].to_i - piece_end[1].to_i).abs

    start_row = piece_start[0].to_i
    start_col = piece_start[1].to_i
    end_row = piece_end[0].to_i
    end_col = piece_end[1].to_i

    loop_result = false
    @col = start_col

    if start_row > end_row
      index = start_row - 1
      while index <= end_row
        loop_result = bishop_move(territories, start_col, end_col, index)
        puts "index #{index}, end_row #{end_row}, loop_result #{loop_result}, col #{@col}"
        index -= 1
      end
    else
      index = start_row + 1
      while index <= end_row
        puts "index #{index}, end_row #{end_row}, loop_result #{loop_result}, col #{@col}"
        loop_result = bishop_move(territories, start_col, end_col, index)
        index += 1
      end
    end

    row_move == col_move && loop_result
  end

  def validate_rock_move(piece_start, piece_end, territories)
    true
  end

  def validate_king_move(piece_start, piece_end, territories)
    true
  end

  def validate_pawn_move(piece_start, piece_end, occupier, turn)
    true
  end

  def validate_queen_move(piece_start, piece_end)
    true
  end

  def validate_move(last_piece, starting_position, ending_position, occupier, turn, map)
      piece_start = starting_position.split(':')
      piece_end = ending_position.split(':')

      case last_piece
        when "Knight"
          then validate_knight_move(piece_start, piece_end)
        when "Bishop"
          then validate_bishop_move(piece_start, piece_end, map)
        when "Rock"
          then validate_rock_move(piece_start, piece_end, map)
        when "King"
          then validate_king_move(piece_start, piece_end, map)
        when "Pawn"
          then validate_pawn_move(piece_start, piece_end, occupier, turn)
        when "Queen"
          then validate_queen_move(piece_start, piece_end)
        else
            false
      end
    end


end
