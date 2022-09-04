class RoomsChannel < ApplicationCable::Channel
  require 'chess'
  require 'chess_in_mem_cache'

  @turn = "Black"

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

  def move_piece(source_row, source_col, destination_row, destination_col)
    temp = @board[destination_row][destination_col]
    @board[destination_row][destination_col] = @board[source_row][source_col]
    @board[source_row][source_col] = temp
    true
  end

  def validate_knight_move(piece_start, piece_end)
    row_move = (piece_start[0].to_i - piece_end[0].to_i).abs
    col_move = (piece_start[1].to_i - piece_end[1].to_i).abs
    puts 'knight validation'
    if row_move + col_move === 3
      temp = @board[piece_end[0].to_i][piece_end[1].to_i]
      @board[piece_end[0].to_i][piece_end[1].to_i] = @board[piece_start[0].to_i][piece_start[1].to_i]
      @board[piece_start[0].to_i][piece_start[1].to_i] = temp
      puts @board[piece_end[0].to_i][piece_end[1].to_i]
      puts @board[piece_start[0].to_i][piece_start[1].to_i]
      puts Marshal.dump(@board)
      true
    end
  end

  def bishop_blocked?(map, start_col, end_col, index)
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

  def validate_bishop_move(source, destination, territories)
    row_move = (source[0].to_i - destination[0].to_i).abs
    col_move = (source[1].to_i - destination[1].to_i).abs

    source_row = source[0].to_i
    source_col = source[1].to_i

    destination_row = destination[0].to_i
    destination_col = destination[1].to_i

    if row_move != col_move
      false
    end

    loop_result = false
    @col = source_col

    if source_row > destination_row 
      (source_row - 1).downto(destination_row) do |index|
        loop_result = bishop_blocked?(territories, source_col, destination_col, index)
      end
    else
      (source_row + 1).upto(destination_row) do |index|
        loop_result = bishop_blocked?(territories, source_col, destination_col, index)
      end
    end

    loop_result
  end

  def validate_rock_move(source, destination)
    source_row = source[0].to_i
    source_col = source[1].to_i

    destination_row = destination[0].to_i
    destination_col = destination[1].to_i

    reached_end = false
    dest_territory_team = @board[source_row][destination_col][:team]

    if source_row == destination_row
      if source_col > destination_col

        (source_col + 1).upto(destination_col) do |col|
          reached_end = col == destination_col
          if @board[source_row][col][:team] != ''
            break
          end
        end
        
        reached_end && dest_territory_team != @turn ? move_piece(source_row, source_col, destination_row, destination_col) : false
      else
        (source_col - 1).downto(destination_col) do |col|
          reached_end = col == destination_col
          if @board[source_row][col][:team] != ''
            break
          end
        end
        
        reached_end && dest_territory_team != @turn ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
    end

    if source_col == destination_col
      if source_row > destination_row

        (source_row + 1).upto(destination_row) do |row|
          reached_end = row == destination_row
          if @board[row][source_col][:team] != ''
            break
          end
        end
        
        reached_end && dest_territory_team != @turn ? move_piece(source_row, source_col, destination_row, destination_col) : false
      else
        (source_row - 1).downto(destination_row) do |row|
          reached_end = row == destination_row
          if @board[row][source_col][:team] != ''
            break
          end
        end
        
        reached_end && dest_territory_team != @turn ? move_piece(source_row, source_col, destination_row, destination_col) : false
      end
    end

    false
  end

  def validate_king_move(piece_start, piece_end, territories)
    temp = @board[piece_end[0].to_i][piece_end[1].to_i]
    @board[piece_end[0].to_i][piece_end[1].to_i] = @board[piece_start[0].to_i][piece_start[1].to_i]
    @board[piece_start[0].to_i][piece_start[1].to_i] = temp
    true
  end

  def validate_pawn_move(piece_start, piece_end, occupier, turn)
    temp = @board[piece_end[0].to_i][piece_end[1].to_i]
    @board[piece_end[0].to_i][piece_end[1].to_i] = @board[piece_start[0].to_i][piece_start[1].to_i]
    @board[piece_start[0].to_i][piece_start[1].to_i] = temp
    true
  end

  def validate_queen_move(piece_start, piece_end)
    temp = @board[piece_end[0].to_i][piece_end[1].to_i]
    @board[piece_end[0].to_i][piece_end[1].to_i] = @board[piece_start[0].to_i][piece_start[1].to_i]
    @board[piece_start[0].to_i][piece_start[1].to_i] = temp
    puts @board
    puts piece_end[0].to_i, piece_end[1].to_i
    puts piece_start[0].to_i, piece_start[1].to_i
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
          then validate_rock_move(piece_start, piece_end)
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
