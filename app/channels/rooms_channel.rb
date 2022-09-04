class RoomsChannel < ApplicationCable::Channel
  require 'chess'
  require 'chess_in_mem_cache'

  $cache = ChessInMemCache.instance
  @@turn = "Blue"

  @@types = {
    msg: "TEXT_MESSAGE",
    command: "TEXT_COMMAND",
    piece_move: "MOVE_VALIDATION"
  }
  def subscribed
    @board = $cache.get_chess_board(params[:room])
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

  def handle_piece_move(message)
    move = message["data"]

    is_valid_move = validate_move(move["source_piece"], move["source_str"], move["destination_str"])

    response = {
      message_type: "MOVE_VALIDATION_RECEIVED",
      move: {
        start: message["data"]["source_str"].split(':'),
        end: message["data"]["destination_str"].split(':'),
        isValid: is_valid_move
      }
    }

    ActionCable.server.broadcast "rooms_#{params[:room]}", response
  end

  def move_piece(source_row, source_col, destination_row, destination_col)
    @board[destination_row][destination_col][:piece] = @board[source_row][source_col][:piece]
    @board[destination_row][destination_col][:team] = @board[source_row][source_col][:team]

    @board[source_row][source_col][:piece] = ''
    @board[source_row][source_col][:team] = ''
    true
  end

  def validate_knight_move(source, destination)
    row_move = (source[0].to_i - destination[0].to_i).abs
    col_move = (source[1].to_i - destination[1].to_i).abs

    if row_move + col_move === 3
      move_piece(source[0].to_i, source[0].to_i, destination[0].to_i, destination[1].to_i)
    end
  end

  def validate_bishop_move(source, destination)
    row_move = (source[0].to_i - destination[0].to_i).abs
    col_move = (source[1].to_i - destination[1].to_i).abs

    source_row = source[0].to_i
    source_col = source[1].to_i

    destination_row = destination[0].to_i
    destination_col = destination[1].to_i

    if row_move != col_move
      return false
    end

    reached_end = false
    col = source_col

    if source_row > destination_row 
      (source_row - 1).downto(destination_row) do |row|
        if destination_col > source_col
          col += 1
          reached_end = col == destination_col
          if @board[row][col][:team] != ""
            break
          end
        else
          col -= 1
          reached_end = col == destination_col
          if @board[row][col][:team] != ""
            break
          end
        end
      end
    else
      (source_row + 1).upto(destination_row) do |row|
        if destination_col > source_col
          col += 1
          reached_end = col == destination_col
          if @board[row][col][:team] != ""
            break
          end
        else
          col -= 1
          reached_end = col == destination_col
          if @board[row][col][:team] != ""
            break
          end
        end
      end
    end

    reached_end ? move_piece(source_row, source_col, destination_row, destination_col) : false
  end

  def validate_rock_move(source, destination)
    source_row = source[0].to_i
    source_col = source[1].to_i

    destination_row = destination[0].to_i
    destination_col = destination[1].to_i

    reached_end = false
    dest_territory_team = @board[destination_row][destination_col][:team]
    not_ally_territory = dest_territory_team != @@turn

    if source_row == destination_row
      if source_col > destination_col

        (source_col - 1).downto(destination_col) do |col|
          reached_end = col == destination_col
          if @board[source_row][col][:team] != ''
            break
          end
        end
        
        return reached_end && not_ally_territory ? move_piece(source_row, source_col, destination_row, destination_col) : false
      else
        (source_col + 1).upto(destination_col) do |col|
          reached_end = col == destination_col
          if @board[source_row][col][:team] != ''
            break
          end
        end
        
        return reached_end && not_ally_territory ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
    end

    if source_col == destination_col
      if source_row > destination_row

        (source_row - 1).downto(destination_row) do |row|
          reached_end = row == destination_row
          if @board[row][source_col][:team] != ''
            break
          end
        end
        
        return reached_end && not_ally_territory ? move_piece(source_row, source_col, destination_row, destination_col) : false
      else
        (source_row + 1).upto(destination_row) do |row|
          reached_end = row == destination_row
          if @board[row][source_col][:team] != ''
            break
          end
        end

        return reached_end && not_ally_territory ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
    end
  end

  def validate_king_move(source, destination)
    row_move = (source[0].to_i - destination[0].to_i).abs
    col_move = (source[1].to_i - destination[1].to_i).abs

    if row_move == col_move
      return validate_bishop_move(source, destination)
    end

    validate_rock_move(source, destination)
  end

  def validate_pawn_move(source, destination)
    source_row = source[0].to_i
    source_col = source[1].to_i
    destination_row = destination[0].to_i
    destination_col = destination[1].to_i

    row_move = (source_row - destination_row).abs
    col_move = (source_col - destination_col).abs

    destination_team = @board[destination_row][destination_col][:team]

    if @@turn == "Blue"
      if destination_row < source_row
        return false
      end
      if row_move == 1 && col_move == 1
        return destination_team == "Red" ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
      if col_move != 0
        return false
      end
      if source_row == 1 && (row_move == 1 || row_move == 2)
        return  destination_team != "Red" ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
      destination_team != "Red" && row_move == 1 ? move_piece(source_row, source_col, destination_row, destination_col) : false
    elsif @@turn == "Red"
      if destination_row > source_row
        return false
      end
      if row_move == 1 && col_move == 1
        return destination_team == "Red" ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
      if col_move != 0
        return false
      end
      if source_row == 6 && (row_move == 1 || row_move == 2)
        return  destination_team != "Red" ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
      destination_team != "Red" && row_move == 1 ? move_piece(source_row, source_col, destination_row, destination_col) : false
    end
  end

  def validate_queen_move(source, destination)
    row_move = (source[0].to_i - destination[0].to_i).abs
    col_move = (source[1].to_i - destination[1].to_i).abs

    (row_move === 0 || row_move === 1) && (col_move === 0 || col_move === 1)
  end

  def validate_move(source_piece_type, source_str, destination_str)
      source = source_str.split(':')
      destination = destination_str.split(':')

      case source_piece_type
        when "Knight"
          then validate_knight_move(source, destination)
        when "Bishop"
          then validate_bishop_move(source, destination)
        when "Rock"
          then validate_rock_move(source, destination)
        when "King"
          then validate_king_move(source, destination)
        when "Pawn"
          then validate_pawn_move(source, destination)
        when "Queen"
          then validate_queen_move(source, destination)
        else
          false
      end
    end


end
